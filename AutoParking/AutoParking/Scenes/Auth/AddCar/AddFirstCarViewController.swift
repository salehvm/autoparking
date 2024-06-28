//
//  AddFirstCarViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork
import RealmSwift

protocol AddFirstCarDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: AddFirstCar.Load.ViewModel)
    
    func displayGetCarList(viewModel: AddFirstCar.VehicleList.ViewModel)
}

final class AddFirstCarViewController: UIViewController {
    
    var mainView: AddFirstCarView?
    var interactor: AddFirstCarBusinessLogic?
    var router: (AddFirstCarRoutingLogic & AddFirstCarDataPassing)?
  
    
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.showBackButton = false
        self.title = "Add First Car"
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
        DispatchQueue.main.async {
            self.mainView?.cars = viewModel.data
            self.mainView?.carPicker.reloadAllComponents() 
        }
    }
    
    private func addNewCarToDevice(car: Vehicle?, deviceName: String) {
        
        
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

       do {
           try realm.write {
               realm.add(newVehicle)
               App.router.main()
               print("Added new car with device name: \(deviceName)")
           }
           
           
           printAllCars()
           print("Added new car with device name: \(deviceName)")
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
}

// MARK: - View Delegate

extension AddFirstCarViewController: AddFirstCarViewDelegate {

       func didTapAddCar(selectedCar: Vehicle?, deviceName: String) {
        
        guard !deviceName.isEmpty else {
            showAlert("Device name is required.")
            return
        }
        
        guard let car = selectedCar else {
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

        do {
            try realm.write {
                realm.add(newVehicle, update: .all)
                print("Added new car with device name: \(deviceName)")
            }
        } catch {
            print("Failed to add new car to Realm: \(error)")
        }
    }
}
