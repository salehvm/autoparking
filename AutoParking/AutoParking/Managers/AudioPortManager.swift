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

protocol AudioRouteChangeDelegate: AnyObject {
    func didChangeAudioRoute(output: String, type: String, message: String)
}

final class AudioPortManager: NSObject {
    
    static let shared = AudioPortManager()
    
    weak var delegate: AudioRouteChangeDelegate?
    
    private var service: ServiceProtocol = App.service
    
    var selectedPaymentMethod: [PaymentMethod]? = []
    
    var cars: Results<VehicleRealm>!
    
    var activeCar: VehicleRealm?
    
    @objc dynamic var currentOutput: String = "No device connected"
    @objc dynamic var currentType: String = "No device connected"
    @objc dynamic var routeChangeMessage: String = "Listening for changes..."
    
    override init() {
        super.init()
        setupAudioSession()
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
    
    
    func startBook(selectedCardId: String, completion: ((Bool) -> ())? = nil) {
        guard let token = SessionManager.shared.accessToken, let minKey = LocationManager.shared.minKey else {
            print("Authentication token or park location key is missing.")
            completion?(false)
            return
        }

        if let defaultPaymentMethod = selectedPaymentMethod?.first(where: { $0.default == 1 }) {
            self.service.auth.startBook(token: token, parkId: minKey, selectedCarId: selectedCardId, selectedPaymentMethod: defaultPaymentMethod) { [weak self] result in
                
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    
                    print("success response start book")
                    print(response.data)
                    
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
            case .success(let response):
                
                print("success response stop book")
                print(response.data)
                
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
            switch result {
            case .success(let response):
                if let bookings = response.data {
                    for booking in bookings {
                        if booking.car?.id == car.id {
                            print("Matching booking found for car \(car.id). Stopping booking with ID \(booking.id ?? "unknown")")
                            if let bookingId = booking.id {
                                self?.stopBook(userParkId: bookingId) { success in
                                    print(success ? "Booking successfully stopped." : "Failed to stop booking.")
                                }
                            }
                        }
                    }
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

            let realm = try! Realm()
            cars = realm.objects(VehicleRealm.self)

            if cars.isEmpty {
                print("No vehicle found with device name: \(output.portName)")
            } else {
                
                for car in cars {
                    
                    if output.portName == car.deviceName {
                        
                        self.activeCar = car
                        
                        print("equal")
                        fetchAndStopBooking(for: car)
                        
                        
                    } else {
                        if self.activeCar?.id == car.id {
                            let token = SessionManager.shared.accessToken ?? ""
                            
                            service.auth.getPaymentCards(token: token) { result in
                                switch result {
                                case .success(let response):
                                    
                                    self.selectedPaymentMethod = response.data
                                    
                                    self.startBook(selectedCardId: self.activeCar?.id ?? "")
                                case .failure(let error):
                                  break
                                case .successNoContent:
                                    break
                                case .wrong(_):
                                    break
                                }
                            }
                        }
                    }
                }
            }
        } else {
            currentOutput = "No device connected"
            currentType = "No device connected"
        }
        print("Current output: \(currentOutput)")
        print("Current output type: \(currentType)")
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .newDeviceAvailable:
            updateCurrentOutput()
            routeChangeMessage = "New device available, such as headphones or a Bluetooth audio device."
        case .oldDeviceUnavailable:
            updateCurrentOutput()
            routeChangeMessage = "Old device unavailable, such as headphones or a Bluetooth audio device being disconnected."
        case .categoryChange:
            routeChangeMessage = "Category change"
        default:
            routeChangeMessage = "Audio route changed"
        }

        
        delegate?.didChangeAudioRoute(output: currentOutput, type: currentType, message: routeChangeMessage)
    }
}

