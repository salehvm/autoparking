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
    func didTapAddCar(selectedCar: Vehicle?, deviceName: String)
}

// ...

final class AddFirstCarView: UIView {
    
    weak var delegate: AddFirstCarViewDelegate?
    
    var cars: [Vehicle] = [] {
        didSet {
            self.carPicker.reloadAllComponents()
            if !cars.isEmpty {
                self.carPicker.selectRow(selectedCarIndex, inComponent: 0, animated: false)
                self.selectedCar = cars[selectedCarIndex]
            }
        }
    }
    
    private var selectedCarIndex: Int = 0 // Add this variable to store the selected index
    private var selectedCar: Vehicle?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ilk maşınınızı daxil edin"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Maşınıza bağlı olan cihazı əlavə edərək, parklanma əməliyyatını sürətləndirməyə dəstək olacağıq."
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let carPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let deviceNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Maşına bağlı cihaz adı"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Car", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupActions()
        
        self.carPicker.delegate = self
        self.carPicker.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(self.titleLabel)
        addSubview(self.descriptionLabel)
        addSubview(self.carPicker)
        addSubview(self.deviceNameTextField)
        addSubview(self.addButton)
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.carPicker.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        
        self.deviceNameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.carPicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.addButton.snp.makeConstraints { make in
            make.top.equalTo(self.deviceNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        self.addButton.addTarget(self, action: #selector(addCarButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addCarButtonTapped() {
        if let delegate = self.delegate {
            delegate.didTapAddCar(selectedCar: selectedCar, deviceName: self.deviceNameTextField.text ?? "")
        }
    }
}

extension AddFirstCarView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let v = view as? UILabel {
            label = v
        } else {
            label = UILabel()
        }
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "\(cars[row].mark?.label ?? "") - \(cars[row].number ?? "")"
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCarIndex = row 
        selectedCar = cars[row]
    }
}
