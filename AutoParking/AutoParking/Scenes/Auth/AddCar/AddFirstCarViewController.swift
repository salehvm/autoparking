//
//  AddFirstCarViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork
import RealmSwift
import AVFAudio
import AVFoundation

protocol AddFirstCarDisplayLogic: AnyObject {
    func displayLoad(viewModel: AddFirstCar.Load.ViewModel)
    func displayGetCarList(viewModel: AddFirstCar.VehicleList.ViewModel)
}

final class AddFirstCarViewController: UIViewController {
    
    var mainView: AddFirstCarView?
    var interactor: AddFirstCarBusinessLogic?
    var router: (AddFirstCarRoutingLogic & AddFirstCarDataPassing)?
    
    var selectedCar: Vehicle?
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        self.view = mainView
        mainView?.delegate = self
        self.showBackButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.load()
    }
  
    // MARK: - Public Methods
  
    func load() {
        let request = AddFirstCar.Load.Request()
        interactor?.load(request: request)
    }
    
    func getCarList() {
        let request = AddFirstCar.VehicleList.Request()
        interactor?.getCarlist(request: request)
    }
}

// MARK: - Display Logic

extension AddFirstCarViewController: AddFirstCarDisplayLogic {
    
    func displayLoad(viewModel: AddFirstCar.Load.ViewModel) {
        self.getCarList()
    }
    
    func displayGetCarList(viewModel: AddFirstCar.VehicleList.ViewModel) {
        let view = SelectCarBottomSheet(cars: viewModel.data) { selectCar in
            self.selectedCar = selectCar
            self.mainView?.selectCarViewLabel.text = selectCar.mark?.label
        }
        
        self.showBottomUp(view)
        if viewModel.data.isEmpty {
            self.mainView?.selectCarViewLabel.text = "No cars available"
        } else {
            self.selectedCar = viewModel.data.first
            self.mainView?.selectCarViewLabel.text = viewModel.data.first?.mark?.label
        }
    }

    private func addNewCarToDevice(car: Vehicle?, deviceName: String, deviceUUID: String) {
        guard let car = car else {
            print("Error: Car information is incomplete or not provided.")
            return
        }

        let realm = try! Realm()
        let newVehicle = VehicleRealm()
        newVehicle.id = car.id ?? ""
        newVehicle.deviceName = deviceName
        newVehicle.number = car.number ?? ""
        newVehicle.markLabel = car.mark?.label ?? ""
        newVehicle.modelLabel = car.model?.label ?? ""
        newVehicle.deviceUUID = deviceUUID

        let autoNotification = AutoNotification()
        autoNotification.isAutoCheck = true

        do {
            try realm.write {
                realm.add(newVehicle, update: .all)
                realm.add(autoNotification)
                print("Added new car with device name: \(deviceName) and isAutoCheck: \(autoNotification.isAutoCheck)")
            }
            printAllCars()
        } catch {
            print("Failed to add new car to Realm: \(error)")
        }
    }
    
    private func printAllCars() {
        let realm = try! Realm()
        let allVehicles = realm.objects(VehicleRealm.self)
        allVehicles.forEach { vehicle in
            print("Car: \(vehicle.number), Device: \(vehicle.deviceName)")
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func playSilentAudioClip() {
        guard let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") else {
            print("Silent audio file not found.")
            return
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = 0.0
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error playing silent audio clip: \(error.localizedDescription)")
        }
    }
}

// MARK: - View Delegate

extension AddFirstCarViewController: AddFirstCarViewDelegate {

    func didTapAddCar(deviceName: String) {
        guard !deviceName.isEmpty else {
            showAlert("Device name is required.")
            return
        }
        
        // Silent audio clip oynatmaqla audio sessiyanı yenilə
        playSilentAudioClip()
        
        // 1 saniyə gecikmə əlavə edirik ki, audio sessiya tam yenilənsin
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            let currentRoute = AVAudioSession.sharedInstance().currentRoute
            print("current route add new car: \(String(describing: currentRoute.outputs.first))")
            
            guard let output = currentRoute.outputs.first else {
                self.showAlert("No audio output detected. Please connect your Bluetooth device.")
                return
            }
            
            if output.uid == "Built-In Receiver" || output.portName.lowercased().contains("speaker") {
                self.showAlert("Please connect your Bluetooth device to proceed.")
                return
            }
            
            // UID-dən yalnız MAC ünvan hissəsini çıxarırıq
            let uid = output.uid.macAddress
            print("Device MAC: \(uid)")
            
            self.addNewCarToDevice(car: self.selectedCar, deviceName: deviceName, deviceUUID: uid)
            self.router?.routeToPermissionScreen()
        }
    }

    func showCarList() {
        self.getCarList()
    }
}

extension String {
    var macAddress: String {
        return self.components(separatedBy: "-").first ?? self
    }
}
