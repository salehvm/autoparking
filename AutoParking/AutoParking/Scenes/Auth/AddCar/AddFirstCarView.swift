//
//  AddFirstCarView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import SnapKit
import AutoParkingNetwork

protocol AddFirstCarViewDelegate: AnyObject {
    func didTapAddCar(deviceName: String)
    
    func showCarList()
}

final class AddFirstCarView: UIView {
    
    weak var delegate: AddFirstCarViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Avtomobil əlavə et"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Qeydiyyatda olan maşınlardan biri və ya bir neçəsini əlavə edə bilərsiniz"
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    private lazy var selectCarLabel: UILabel = {
        let label = UILabel()
        label.text = "Avtomobili seç"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: "1C2024")
        return label
    }()
    
    private lazy var selectCarView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.init(hex: "000932").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var selectCarViewLabel: UILabel = {
        let label = UILabel()
        label.text = "Seç"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var selectCarViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron-down")
        return imageView
    }()
    
    private lazy var deviceTitle: UILabel = {
        let label = UILabel()
        label.text = "Cihazın adı"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: "1C2024")
        return label
    }()
    
    private lazy var deviceView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.init(hex: "000932").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let deviceNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Maşına bağlı cihaz adı"
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Əlavə et", for: .normal)
        button.backgroundColor = UIColor(hex: "ECEEF4")
        button.setTitleColor(UIColor(hex: "000830"), for: .normal)
        button.layer.cornerRadius = 22
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupActions()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.selectCarLabel)
        self.addSubview(self.selectCarView)
        self.selectCarView.addSubview(self.selectCarViewLabel)
        self.selectCarView.addSubview(self.selectCarViewIcon)
        self.addSubview(self.deviceTitle)

        self.addSubview(self.deviceView)
        self.deviceView.addSubview(self.deviceNameTextField)

        self.addSubview(self.addButton)

        self.selectCarView.addTapGesture {
            if let delegate = self.delegate {
                delegate.showCarList()
            }
        }

        self.backgroundColor = .white

        updateButtonState()
    }
    
    private func setupConstraints() {
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().offset(28)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        self.selectCarLabel.snp.updateConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        self.selectCarView.snp.updateConstraints { make in
            make.top.equalTo(self.selectCarLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(40)
        }
        
        self.selectCarViewLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalTo(self.selectCarViewIcon.snp.leading).offset(8)
        }
        
        self.selectCarViewIcon.snp.updateConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
        }
        
        self.deviceTitle.snp.updateConstraints { make in
            make.top.equalTo(self.selectCarView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        self.deviceView.snp.updateConstraints { make in
            make.top.equalTo(self.deviceTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(40)
        }
        
        self.deviceNameTextField.snp.updateConstraints { make in
            make.trailing.bottom.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        self.addButton.snp.makeConstraints { make in
            make.top.equalTo(self.deviceView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
    }
    
    private func setupActions() {
        self.addButton.addTarget(self, action: #selector(addCarButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldDidChange() {
        updateButtonState()
    }
    
    @objc private func addCarButtonTapped() {
        if let delegate = self.delegate {
            delegate.didTapAddCar(deviceName: self.deviceNameTextField.text ?? "")
        }
    }
    
    private func updateButtonState() {
        let text = deviceNameTextField.text ?? ""
        let isEnabled = !text.isEmpty
        addButton.isEnabled = isEnabled
        if isEnabled {
            addButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
            addButton.backgroundColor = UIColor(hex: "0090FF")
        } else {
            addButton.setTitleColor(UIColor(hex: "000830"), for: .normal)
            addButton.backgroundColor = UIColor(hex: "ECEEF4")
        }
    }
}
