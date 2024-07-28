//
//  AudioPortManager.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/06/2024.
//

import Foundation
import AVFoundation
import RealmSwift
import AutoParkingNetwork
import UserNotifications
import CoreLocation
import Turf

protocol AudioRouteChangeDelegate: AnyObject {
    func didChangeAudioRoute(output: String, type: String, message: String)
}

protocol AudioPortManagerDelegate {
    func fetchParksAudioCompletion(status: Bool)
}

final class AudioPortManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = AudioPortManager()
    
    weak var delegate: AudioRouteChangeDelegate?
    var locationManager = CLLocationManager()
    
    private var location: CLLocation?
    
    private var service: ServiceProtocol = App.service
    
    var allPaymentMethods: [PaymentMethod]? = []
    var selectedPaymentMethod: PaymentMethod?
    
    var cars: Results<VehicleRealm>!
    
    var activeCar: VehicleRealm?
    
    var parks: [Park]? = []
    
    var customLocationArray: [CustomModelLocation] = []
    
    let delegates = MulticastDelegate<AudioPortManagerDelegate>()
    
    @objc dynamic var currentOutput: String = "No device connected"
    @objc dynamic var currentType: String = "No device connected"
    @objc dynamic var routeChangeMessage: String = "Listening for changes..."
    
    override init() {
        super.init()
        setupAudioSession()
        setupLocationManager()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, options: [.allowBluetooth, .allowBluetoothA2DP])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            updateCurrentOutput()
        } catch {
            print("Failed to activate audio session: \(error)")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func requestCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        locationManager.requestLocation()
        completion(self.location)
    }
    
    private func sendPushNotification(title: String, body: String, parkId: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: 1)
        content.userInfo = ["parkId": parkId]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification request: \(error)")
            } else {
                print("Notification scheduled: \(title) - \(body)")
            }
        }
    }
    
    private func fetchParksAudioCompletion(status: Bool) {
        self.delegates.invoke(invocation: { $0.fetchParksAudioCompletion(status: status) })
    }
    
    func fetchParks(completion: ((Bool, [Park]) -> ())? = nil) {
        let token = SessionManager.shared.accessToken ?? ""
        guard let location = self.location else {
            print("Location is nil, cannot fetch parks")
            completion?(false, [])
            return
        }
        self.service.park.getParkList(token: token, location: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let park):
                self.parks = park.data
                
                completion?(true, park.data ?? [])
                self.fetchParksAudioCompletion(status: true)
                
            case .wrong(_):
                completion?(false, [])
                self.fetchParksAudioCompletion(status: false)
                
            default:
                completion?(false, [])
                self.fetchParksAudioCompletion(status: false)
            }
        }
    }
    
    func startBook(selectedCardId: String, parkId: String, completion: ((Bool) -> ())? = nil) {
        guard let token = SessionManager.shared.accessToken else {
            print("Authentication token or park location key is missing.")
            completion?(false)
            return
        }

        if let defaultPaymentMethod = selectedPaymentMethod {
            self.service.auth.startBook(token: token, parkId: parkId, selectedCarId: selectedCardId, selectedPaymentMethod: defaultPaymentMethod) { [weak self] result in
                
                guard self != nil else { return }
                switch result {
                case .success(_):
                    print("success response start book")
                    
                    completion?(true)
                case .failure(let error):
                    print("Booking failed with error: \(error.localizedDescription)")
                    completion?(false)
                default:
                    print("Unhandled result in booking process.")
                    completion?(false)
                }
            }
        } else {
            print("Default payment method not found.")
            completion?(false)
        }
    }
    
    func stopBook(userParkId: String, completion: ((Bool) -> ())? = nil) {
        guard let token = SessionManager.shared.accessToken else {
            print("Authentication token or park location key is missing.")
            completion?(false)
            return
        }
        
        self.service.auth.stopBook(token: token, userParkId: userParkId) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("success response stop book")
                self.sendPushNotification(title: "Successfully Stopped Park", body: "Your parking session has ended successfully.", parkId: userParkId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    App.router.main()
                }
                completion?(true)
            case .failure(let error):
                print("Booking failed with error: \(error.localizedDescription)")
                completion?(false)
            default:
                print("Unhandled result in booking process.")
                completion?(false)
            }
        }
    }
    
    private func fetchAndStopBooking(for car: VehicleRealm) {
        guard let token = SessionManager.shared.accessToken else {
            print("Authentication token is missing.")
            return
        }

        let ts = Int(Date().timeIntervalSince1970)
        let request = BookedListRequest(token: token,
                                        template: "4",
                                        source: "20",
                                        type: "user",
                                        lang: "az",
                                        version: "20",
                                        vs: 20,
                                        device: "iOS",
                                        ts: "\(ts)",
                                        dataId: 0,
                                        dataActive: 1,
                                        dataSkip: 0,
                                        dataLimit: 10,
                                        dataSort: "created_at",
                                        dataSortType: "desc",
                                        dataFrom: "time",
                                        dataType: "ongoing")

        service.book.getBookedList(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let bookings = response.data {
                    for booking in bookings {
                        if let bookingCarId = booking.car?.id, bookingCarId == car.id {
                            print("Matching booking found for car \(car.id). Stopping booking with ID \(booking.id ?? "unknown")")
                            if let bookingId = booking.id {
                                self.stopBook(userParkId: bookingId) { success in
                                    print(success ? "Booking successfully stopped." : "Failed to stop booking.")
                                }
                            }
                        }
                    }
                } else {
                    print("No bookings found in response data.")
                }
            case .failure(let error):
                print("Failed to fetch bookings: \(error.localizedDescription)")
            default:
                print("Unhandled result in booking process.")
            }
        }
    }
    
    private func updateCurrentOutput() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if let output = currentRoute.outputs.first {
            currentOutput = output.portName
            currentType = output.portType.rawValue

            print("Output port name: \(output.portName)")
            print("Output port type: \(output.portType.rawValue)")

            let realm = try! Realm()
            cars = realm.objects(VehicleRealm.self)
            

            if cars.isEmpty {
                print("No vehicle found with device name: \(output.portName)")
            } else {
                for car in cars {
                    if output.portName == car.deviceName {
                        self.activeCar = car
                        fetchAndStopBooking(for: car)
                    } else {
                        if self.activeCar?.id == car.id {
                            
//                            let gregorian = Calendar(identifier: .gregorian)
//                            let date = Date()
//                            let day = gregorian.component(.weekday, from: date)
                            
//                            if day != 1 {
                                locationManager.startUpdatingLocation()
//                            }
                            
                        }
                    }
                }
            }
        } else {
            currentOutput = "Built-in Receiver"
            currentType = AVAudioSession.Port.builtInReceiver.rawValue
            self.activeCar = nil
        }
        delegate?.didChangeAudioRoute(output: currentOutput, type: currentType, message: routeChangeMessage)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last, bestLocation.horizontalAccuracy < 15 else {
            print("Failed to get a valid location")
            return
        }
        
        let customLocation = CustomModelLocation(
            horizontalAccuracy: bestLocation.horizontalAccuracy
        )
        
        self.customLocationArray.append(customLocation)
        
        locationManager.stopUpdatingLocation()
        
        self.location = bestLocation
        print("Best location updated: \(bestLocation)")
            
        let token = SessionManager.shared.accessToken ?? ""
        self.service.auth.getPaymentCards(token: token) { result in
            switch result {
            case .success(let response):
                self.allPaymentMethods = response.data
                
                self.selectedPaymentMethod = response.data.first(where: { $0.default == 1 })
            
                self.fetchParks { success, data in
                    
                    print(data)
                    
                    if success,
                       
                       let closestPark = LocationManager.shared.calculateClosestPoints(location: bestLocation, parks: data) {
                        
                        let realm = try! Realm()
                        if let autoNotification = realm.objects(AutoNotification.self).first, !autoNotification.isAutoCheck {
                            self.sendPushNotification(title: "For you", body: "We detect you stay here \(closestPark.code ?? "") if you want us to park for you, let us", parkId: closestPark.id ?? "")
                        } else {
                            self.sendPushNotification(title: "Start Booked Park", body: "Your parking session has started successfully.", parkId: closestPark.id ?? "")
                          
                            self.startBook(selectedCardId: self.activeCar?.id ?? "", parkId: closestPark.id ?? "")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                App.router.main()
                            }
                            
                        }
                        
                    } else {
                        print("Failed to find the closest park or fetch parks")
                    }
                }
            case .failure(let error):
                print("Failed to get payment cards: \(error.localizedDescription)")
            case .successNoContent:
                print("No content in payment cards response")
            case .wrong(let message):
                print("Wrong response: \(message)")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get current location: \(error.localizedDescription)")
    }

    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .newDeviceAvailable,  .categoryChange:
            updateCurrentOutput()
            routeChangeMessage = "New device available, such as headphones or a Bluetooth audio device."
            
        case .oldDeviceUnavailable:
            updateCurrentOutput()
            routeChangeMessage = "Old device unavailable, such as headphones or a Bluetooth audio device being disconnected."
        default:
            routeChangeMessage = "Audio route changed"
        }

        delegate?.didChangeAudioRoute(output: currentOutput, type: currentType, message: routeChangeMessage)
    }
}

struct CustomModelLocation {
    let horizontalAccuracy: Double
}
