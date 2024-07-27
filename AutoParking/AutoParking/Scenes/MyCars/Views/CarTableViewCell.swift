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
    func canDelete(vehicleId: String, vehicleName: String)
}

final class CarTableViewCell: UITableViewCell, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    weak var delegate: CarTableViewCellDelegate?
    
    var deviceNameChanged: ((String) -> Void)?
    
    var vehicle = VehicleRealm()
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: "ACD8FC").withAlphaComponent(0.1)
        view.layer.borderColor = UIColor.init(hex: "ACD8FC").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var carName: UILabel = {
        let label = UILabel()
        label.text = "Avtomobilin adı:"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: "838383")
        return label
    }()
    
    private lazy var carLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    private lazy var deviceNameTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: "838383")
        label.text = "Blutuzun adı:"
        return label
    }()
    
    private lazy var deviceName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    private lazy var hStachView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = "Düzəliş et"
        config.image = UIImage(named: "edit_icon")
        config.imagePadding = 8
        config.baseForegroundColor = UIColor.init(hex: "006DCB")
        config.background.cornerRadius = 16
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.init(hex: "006DCB")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        button.configuration = config
        button.addTarget(self, action: #selector(editDeviceName), for: .touchUpInside)
        
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.title = "Sil"
        config.image = UIImage(named: "delete_icon")
        config.imagePadding = 8
        config.baseForegroundColor = UIColor.init(hex: "CE2C31")
        config.background.cornerRadius = 16
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.init(hex: "CE2C31")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        button.configuration = config
        button.addTarget(self, action: #selector(onDeleteCar), for: .touchUpInside)
        
        return button
    }()

    
    func configure(with vehicle: VehicleRealm) {
        self.vehicle = vehicle
        self.carLabel.text = "\(vehicle.markLabel)"
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
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(204)
        }
        
        self.carName.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.carLabel.snp.updateConstraints { make in
            make.top.equalTo(self.carName.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.deviceNameTitle.snp.updateConstraints { make in
            make.top.equalTo(self.carLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.deviceName.snp.updateConstraints { make in
            make.top.equalTo(self.deviceNameTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
        }
        
        self.hStachView.snp.updateConstraints { make in
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        
        super.updateConstraints()
        
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.contentView.addSubview(self.bodyView)
        
        self.bodyView.addSubview(self.carName)
        self.bodyView.addSubview(self.carLabel)
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
            delegate.canDelete(vehicleId: self.vehicle.id, vehicleName: self.vehicle.modelValue)
        }
    }
}


