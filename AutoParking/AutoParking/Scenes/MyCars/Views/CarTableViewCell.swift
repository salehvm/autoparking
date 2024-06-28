//
//  CarTableViewCell.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import AutoParkingUIKit

protocol CarTableViewCellDelegate: AnyObject {
    func canEdit(vehicleId: String, deviceName: String)
    func canDelete(vehicleId: String)
}

final class CarTableViewCell: UITableViewCell, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    weak var delegate: CarTableViewCellDelegate?
    
    var deviceNameChanged: ((String) -> Void)?
    
    var vehicle = VehicleRealm()
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var carName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var deviceNameTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemBrown
        label.text = "Bluetooth name: "
        return label
    }()
    
    private lazy var deviceName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemBrown
        return label
    }()
    
    private lazy var hStachView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(editDeviceName), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(onDeleteCar), for: .touchUpInside)
        return button
    }()
    
    func configure(with vehicle: VehicleRealm) {
        self.vehicle = vehicle
        self.carName.text = "Car name: \(vehicle.markLabel)"
        self.deviceName.text = vehicle.deviceName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews()
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.alpha = highlighted ? 0.6 : 1.0
    }
    
    override func updateConstraints() {
        

        self.bodyView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.height.equalTo(140)
        }
        
        self.carName.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        self.deviceNameTitle.snp.updateConstraints { make in
            make.top.equalTo(self.carName.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        self.deviceName.snp.updateConstraints { make in
            make.top.equalTo(self.carName.snp.bottom).offset(8)
            make.leading.equalTo(self.deviceNameTitle.snp.trailing).offset(6)
        }
        
        self.hStachView.snp.updateConstraints { make in
            make.top.equalTo(self.deviceName.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        
        super.updateConstraints()
        
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.contentView.addSubview(self.bodyView)
        
        self.bodyView.addSubview(self.carName)
        self.bodyView.addSubview(self.deviceNameTitle)
        self.bodyView.addSubview(self.deviceName)
        
        self.bodyView.addSubview(self.hStachView)
        
        self.hStachView.addArrangedSubview(self.editButton)
        self.hStachView.addArrangedSubview(self.deleteButton)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    @objc func editDeviceName() {
        if let delegate = self.delegate {
            delegate.canEdit(vehicleId: self.vehicle.id, deviceName: self.deviceName.text ?? "")
        }
    }
    
    @objc func onDeleteCar() {
        if let delegate = self.delegate {
            delegate.canDelete(vehicleId: self.vehicle.id)
        }
    }
}


