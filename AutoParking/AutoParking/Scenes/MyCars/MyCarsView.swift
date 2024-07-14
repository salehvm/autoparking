//
//  MyCarsView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit

protocol MyCarsViewDelegate: AnyObject {
    func canAddVehicle()
}

final class MyCarsView: UIView {
    
    weak var delegate: MyCarsViewDelegate?
    
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Vehicle", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(canAddAction), for: .touchUpInside)
        return button
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
        
        self.tableView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(32)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.addButton.snp.top).offset(-32)
        }
        
        self.addButton.snp.updateConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(300)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.centerX.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.addSubview(self.tableView)
        self.addSubview(self.addButton)
        
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
