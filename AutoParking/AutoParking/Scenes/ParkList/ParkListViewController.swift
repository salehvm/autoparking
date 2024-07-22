//
//  ParkListViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import AutoParkingNetwork

protocol ParkListDisplayLogic: AnyObject {
    
    func displayLoad(viewModel: ParkList.Load.ViewModel)
    
    func displaygetParkList(viewModel: ParkList.ParkList.ViewModel)
}

final class ParkListViewController: UIViewController {
    
    var mainView: ParkListView?
    var interactor: ParkListBusinessLogic?
    var router: (ParkListRoutingLogic & ParkListDataPassing)?
    
    private var items: [Park] = [] {
        didSet {
            self.mainView?.tableView.reloadData()
        }
    }
    
    private var customLocationArray: [CustomModelLocation] = [] {
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
        
        self.title = "Park List"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.load()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.load()
    }
    // MARK: - Public Methods
  
    func load() {
        let request = ParkList.Load.Request()
        interactor?.load(request: request)
    }
    
    func getParkList() {
        let request = ParkList.ParkList.Request()
        interactor?.getParkList(request: request)
    }
}

// MARK: - Display Logic

extension ParkListViewController: ParkListDisplayLogic {
    
    func displaygetParkList(viewModel: ParkList.ParkList.ViewModel) {
//        self.items = viewModel.data
    }
    
    func displayLoad(viewModel: ParkList.Load.ViewModel) {
        
        self.customLocationArray = AudioPortManager.shared.customLocationArray 
    }
}

// MARK: - View Delegate

extension ParkListViewController: ParkListViewDelegate {
    
}

extension ParkListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customLocationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParkListCell.reuseIdentifier, for: indexPath) as! ParkListCell
        cell.dataLocation = self.customLocationArray[indexPath.row]
        
        
        cell.idName.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
