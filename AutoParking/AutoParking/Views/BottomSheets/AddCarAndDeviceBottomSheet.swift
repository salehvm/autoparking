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
        label.text = "Avtomobil əlavə et"
        label.textColor = UIColor.init(hex: "113264")
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_icon"), for: .normal)
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
    
    private lazy var deviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Cihazın adı"
        label.textColor = UIColor.init(hex: "000033")
        return label
    }()
    
    private lazy var editView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.init(hex: "000033").withAlphaComponent(0.3).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var editTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Cihazın adı"
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Əlavə et", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.init(hex: "0090FF")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
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

        if !vehicles.isEmpty {
            selectedCar = vehicles[0]
            carPicker.selectRow(0, inComponent: 0, animated: false)
        }
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
            make.height.equalTo(140)
            make.top.equalTo(self.lineView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.deviceLabel.snp.updateConstraints { make in
            make.top.equalTo(self.carPicker.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(24)
        }
        
        self.editView.snp.updateConstraints { make in
            make.top.equalTo(self.deviceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        self.editTextField.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(8)
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
        self.view.addSubview(self.deviceLabel)
        
        self.view.addSubview(self.carPicker)
        self.view.addSubview(self.editView)
        self.editView.addSubview(self.editTextField)
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
