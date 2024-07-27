//
//  MyCarsView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit

protocol MyCarsViewDelegate: AnyObject {
    func canAddVehicle()
    func getLocation()
}

final class MyCarsView: UIView {
    
    weak var delegate: MyCarsViewDelegate?
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Avtomobillər"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        button.backgroundColor = UIColor.init(hex: "0090FF")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(canAddAction), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CarTableViewCell.self, forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.sectionFooterHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        return tableView
    }()
    
    lazy var locPermissionView: GlobalLocationPermissionView = {
        let view = GlobalLocationPermissionView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubviews()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        self.title.snp.updateConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        self.tableView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.title.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-32)
        }
        
        self.addButton.snp.updateConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalToSuperview().offset(-28)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        self.locPermissionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.addSubview(self.locPermissionView)
        self.addSubview(self.title)
        self.addSubview(self.addButton)
        self.addSubview(self.tableView)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    @objc func canAddAction() {
        if let delegate = self.delegate {
            delegate.canAddVehicle()
        }
    }
}

extension MyCarsView: GlobalLocationPermissionViewDelegate {
    
    func getLocation() {
        if let delegate = self.delegate {
            delegate.getLocation()
        }
    }
}
