//
//  ActiveParkingViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingNetwork
import CoreLocation

protocol ActiveParkingDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: ActiveParking.Load.ViewModel)
    
    func displayBookingList(viewModel: ActiveParking.BookedList.ViewModel)
}

final class ActiveParkingViewController: UIViewController {
    
    var mainView: ActiveParkingView?
    var interactor: ActiveParkingBusinessLogic?
    var router: (ActiveParkingRoutingLogic & ActiveParkingDataPassing)?
    
    var locationManager = CLLocationManager()
    
    private var items: [Booking] = [] {
        didSet {
            self.mainView?.tableView.reloadData()
        }
    }
  
    // MARK: - Lifecycle Methods

    override func loadView() {
        super.loadView()
        
        self.view = mainView
        mainView?.delegate = self
        
        self.mainView?.tableView.dataSource = self
        self.mainView?.tableView.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioPortManager.shared.delegate = self
        self.checkLocationPermission()
        self.bookedList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkLocationPermission()
        self.bookedList()
    }
  
    // MARK: - Public Methods
  
    func load() {
        let request = ActiveParking.Load.Request()
        interactor?.load(request: request)
    }
    
    func bookedList() {
        let request = ActiveParking.BookedList.Request()
        interactor?.bookedList(request: request)
    }
    
    private func checkLocationPermission() {
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .notDetermined || authorizationStatus == .denied {
            mainView?.locPermissionView.isHidden = false
            mainView?.tableView.isHidden = true
        } else {
            mainView?.locPermissionView.isHidden = true
            mainView?.tableView.isHidden = false
        }
    }
}

// MARK: - Display Logic

extension ActiveParkingViewController: ActiveParkingDisplayLogic {
    
    func displayBookingList(viewModel: ActiveParking.BookedList.ViewModel) {
        
        
        if viewModel.data.isEmpty == true {
            self.mainView?.emptyText.isHidden = false
            self.mainView?.emptyImage.isHidden = false
        } else {
            self.items = viewModel.data
            self.mainView?.emptyText.isHidden = true
            self.mainView?.emptyImage.isHidden = true
        }
    }

    func displayLoad(viewModel: ActiveParking.Load.ViewModel) {
        self.bookedList()
    }
}

// MARK: - View Delegate

extension ActiveParkingViewController: ActiveParkingViewDelegate {
    
    func getLocation() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

extension ActiveParkingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookedListCell.reuseIdentifier, for: indexPath) as! BookedListCell
        cell.data = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ActiveParkingViewController: AudioRouteChangeDelegate {
    
    func didChangeAudioRoute(output: String, type: String, message: String) { }
    
}
