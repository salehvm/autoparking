//
//  ActiveParkingView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol ActiveParkingViewDelegate: AnyObject {
    func getLocation()
}

final class ActiveParkingView: UIView {
    
    weak var delegate: ActiveParkingViewDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Aktiv parklama"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor(hex: "113264")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(BookedListCell.self, forCellReuseIdentifier: BookedListCell.reuseIdentifier)
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
    
    lazy var emptyText: UILabel = {
        let label = UILabel()
        label.text = "Aktiv park yoxdur"
        label.isHidden = true
        label.textColor = UIColor.init(hex: "113264")
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_parking_icon")
        imageView.isHidden = true
        return imageView
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
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        self.tableView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-32)
        }
        
        self.locPermissionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
        
        self.emptyText.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(220)
            make.centerX.equalToSuperview()
        }
        
        self.emptyImage.snp.updateConstraints { make in
            make.top.equalTo(self.emptyText.snp.bottom).offset(16)
            make.size.equalTo(120)
            make.centerX.equalTo(self.emptyText)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.locPermissionView)
        self.addSubview(self.tableView)
        self.addSubview(self.emptyText)
        self.addSubview(self.emptyImage)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
}

extension ActiveParkingView: GlobalLocationPermissionViewDelegate {
    
    func getLocation() {
        if let delegate = self.delegate {
            delegate.getLocation()
        }
    }
}
