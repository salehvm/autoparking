//
//  AddCarAndDeviceBottomSheet.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import AutoParkingUIKit
import SnapKit
import AutoParkingNetwork

final class AddCarAndDeviceBottomSheet: UIViewController, ThemeableViewController {

    var theme: ThemeProvider = App.theme
    
    private var selectCompletion: (String, Vehicle) -> Void = { _,_  in  }
    
    var vehicles: [Vehicle] = []
    private var selectedCar: Vehicle?
    
    // MARK: - View Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add car and device name"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouchUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    let carPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private lazy var editTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "set the new bluetooth name in you device"
        textField.borderStyle = .line
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTouchUp), for: .touchUpInside)
        return button
    }()
    
    @objc var dismissCompletion: (() -> Void)?
   
    // MARK: - Init Methods
    
    init(vehicles: [Vehicle], selectCompletion: @escaping (String, Vehicle) -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.selectCompletion = selectCompletion
        self.vehicles = vehicles
        hideKeyboardWhenTappedAround()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.carPicker.delegate = self
        self.carPicker.dataSource = self
        
        
        self.addSubviews()
        self.setupUI()
    }
    
    override func updateViewConstraints() {
        
        self.titleLabel.snp.updateConstraints { make in
            make.top.equalTo(22)
            make.leading.equalTo(16)
        }
        
        self.closeButton.snp.updateConstraints { make in
            make.top.equalTo(8)
            make.trailing.equalTo(-8)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        self.lineView.snp.updateConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.carPicker.snp.updateConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(self.lineView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.editTextField.snp.updateConstraints { make in
            make.top.equalTo(self.carPicker.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
       
        self.saveButton.snp.updateConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.lineView)
        
        self.view.addSubview(self.carPicker)
        self.view.addSubview(self.editTextField)
        self.view.addSubview(self.saveButton)
        
        self.updateViewConstraints()
        
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
    // MARK: - Action
    
    @objc func closeButtonTouchUp() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.dismissCompletion?()
        }
    }
    
    @objc func saveButtonTouchUp() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            if let selectedCar = self.selectedCar {
                self.selectCompletion(self.editTextField.text ?? "", selectedCar)
            }
            
            
        }
    }
}

extension AddCarAndDeviceBottomSheet: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let v = view as? UILabel {
            label = v
        } else {
            label = UILabel()
        }
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "\(vehicles[row].mark?.label ?? "") - \(vehicles[row].number ?? "")"
        label.textAlignment = .center
        
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCar = vehicles[row]
    }
}
