//
//  MyCarsViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import RealmSwift
import CoreLocation

protocol MyCarsDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: MyCars.Load.ViewModel)
    
    func displayGetCarList(viewModel: MyCars.VehicleList.ViewModel)
}

final class MyCarsViewController: UIViewController {
    
    var mainView: MyCarsView?
    var interactor: MyCarsBusinessLogic?
    var router: (MyCarsRoutingLogic & MyCarsDataPassing)?
    
    var locationManager = CLLocationManager()
    var cars: Results<VehicleRealm>!
  
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.mainView?.tableView.delegate = self
        self.mainView?.tableView.dataSource = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkLocationPermission()
        loadCars()
        self.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkLocationPermission()
        loadCars()
    }
  
    private func loadCars() {
        let realm = try! Realm()
        cars = realm.objects(VehicleRealm.self)
        DispatchQueue.main.async {
            self.mainView?.tableView.reloadData()
        }
    }

    func updateDeviceName(forVehicleId id: String, deviceName: String) {
        let realm = try! Realm()
        if let vehicle = realm.object(ofType: VehicleRealm.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    vehicle.deviceName = deviceName
                    print("Updated device name to \(deviceName) for vehicle ID \(id)")
                }
            } catch {
                print("Failed to update device name: \(error)")
            }
        } else {
            print("No vehicle found with ID \(id)")
        }
    }
    
    private func saveOrUpdateVehicle(selectedCarId: String, deviceName: String, carName: String) {
        let realm = try! Realm()
        if let existingVehicle = realm.object(ofType: VehicleRealm.self, forPrimaryKey: selectedCarId) {
            try! realm.write {
                existingVehicle.deviceName = deviceName
                existingVehicle.markLabel = carName 
                print("Updated \(selectedCarId) with device name \(deviceName) and car name \(carName)")
            }
        } else {
            let newVehicle = VehicleRealm()
            newVehicle.id = selectedCarId
            newVehicle.deviceName = deviceName
            newVehicle.markLabel = carName
            try! realm.write {
                realm.add(newVehicle)
                print("Added new vehicle with ID \(selectedCarId), device name \(deviceName), and car name \(carName)")
            }
        }
        self.loadCars()
    }

    
    // MARK: - Public Methods
  
    func load() {
        let request = MyCars.Load.Request()
        interactor?.load(request: request)
    }
    
    func getCarList() {
        let request = MyCars.VehicleList.Request()
        interactor?.getCarlist(request: request)
    }
    
    private func checkLocationPermission() {
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .notDetermined || authorizationStatus == .denied {
            mainView?.locPermissionView.isHidden = false
            mainView?.addButton.isHidden = true
            mainView?.title.isHidden = true
            mainView?.tableView.isHidden = true
        } else {
            mainView?.locPermissionView.isHidden = true
            mainView?.addButton.isHidden = false
            mainView?.title.isHidden = false
            mainView?.tableView.isHidden = false
        }
    }
}

// MARK: - Display Logic

extension MyCarsViewController: MyCarsDisplayLogic {
    
    func displayLoad(viewModel: MyCars.Load.ViewModel) {
       
    }
    
    func displayGetCarList(viewModel: MyCars.VehicleList.ViewModel) {
        DispatchQueue.main.async {
            let selectView = AddCarAndDeviceBottomSheet(vehicles: viewModel.data) { editedName, selectedCar in
                self.dismiss(animated: true)

                let carName = selectedCar.mark?.label ?? "Default Car Name"

                print("Edited name: \(editedName), Car name: \(carName)")

                self.saveOrUpdateVehicle(selectedCarId: selectedCar.id ?? "", deviceName: editedName, carName: carName)
                self.loadCars()
            }
            
            DispatchQueue.main.async {
                selectView.carPicker.reloadAllComponents()
            }
            
            self.showBottomUp(selectView, sizes: [.fixed(500)])
        }
    }

}

// MARK: - View Delegate

extension MyCarsViewController: MyCarsViewDelegate {
    
    func getLocation() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func canAddVehicle() {
        self.getCarList()
    }
    
}

extension MyCarsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath) as! CarTableViewCell
        let car = cars[indexPath.row]
        print("Configuring cell for car with ID: \(car.id) and name: \(car.markLabel)")
        cell.configure(with: car)
        cell.delegate = self
        
        return cell
    }

}


extension MyCarsViewController: CarTableViewCellDelegate {
    
    func canDelete(vehicleId: String, vehicleName: String) {
        let deleteConfirmationVC = DeleteConfirmationViewController()
        deleteConfirmationVC.vehicleId = vehicleId
        deleteConfirmationVC.delegate = self
        deleteConfirmationVC.modalPresentationStyle = .overCurrentContext
        deleteConfirmationVC.modalTransitionStyle = .crossDissolve
        self.present(deleteConfirmationVC, animated: true, completion: nil)
    }
    
    func canEdit(vehicleId: String, deviceName: String) {
        let realm = try! Realm()
        if let vehicle = realm.object(ofType: VehicleRealm.self, forPrimaryKey: vehicleId) {
            let carName = vehicle.carName

            let selectView = EdirDeviceNameSheet(deviceName: deviceName) { editedName in
                print("New Device Name: \(editedName) vehicleId: \(vehicleId)")
                
              
                self.saveOrUpdateVehicle(selectedCarId: vehicleId, deviceName: editedName, carName: carName)
                self.loadCars()
            }
            self.showBottomUp(selectView, sizes: [.fixed(300)])
        } else {
            print("Vehicle not found with ID \(vehicleId)")
        }
    }
}

extension MyCarsViewController: DeleteConfirmationDelegate {
    
    func didConfirmDeletion(vehicleId: String) {
        let realm = try! Realm()
        if let vehicleToDelete = realm.object(ofType: VehicleRealm.self, forPrimaryKey: vehicleId) {
            do {
                try realm.write {
                    realm.delete(vehicleToDelete)
                    print("Vehicle deleted: \(vehicleId)")
                    self.loadCars()
                }
            } catch {
                print("Error deleting vehicle: \(error)")
            }
        }
    }
}
