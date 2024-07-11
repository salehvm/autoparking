//
//  MyCarsViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import RealmSwift

protocol MyCarsDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: MyCars.Load.ViewModel)
    
    func displayGetCarList(viewModel: MyCars.VehicleList.ViewModel)
}

final class MyCarsViewController: UIViewController {
    
    var mainView: MyCarsView?
    var interactor: MyCarsBusinessLogic?
    var router: (MyCarsRoutingLogic & MyCarsDataPassing)?
    
    var cars: Results<VehicleRealm>!
  
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.mainView?.tableView.delegate = self
        self.mainView?.tableView.dataSource = self
        
        self.title = "My cars"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCars()
        self.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                existingVehicle.markLabel = carName  // Make sure this line is executing
                print("Updated \(selectedCarId) with device name \(deviceName) and car name \(carName)")
            }
        } else {
            let newVehicle = VehicleRealm()
            newVehicle.id = selectedCarId
            newVehicle.deviceName = deviceName
            newVehicle.markLabel = carName  // Ensure this is set for new entries
            try! realm.write {
                realm.add(newVehicle)
                print("Added new vehicle with ID \(selectedCarId), device name \(deviceName), and car name \(carName)")
            }
        }
        self.loadCars()  // Make sure this is called to refresh the list
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
            
            self.showBottomUp(selectView, sizes: [.fixed(350)])
        }
    }

}

// MARK: - View Delegate

extension MyCarsViewController: MyCarsViewDelegate {
    
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
    
    func canDelete(vehicleId: String) {
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
