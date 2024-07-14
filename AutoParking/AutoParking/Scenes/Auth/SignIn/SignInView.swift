//
//  SignInView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingUIKit
import SnapKit

enum OperatorValue: String, CaseIterable {
    case one = "1"
    case two = "2"
    case three = "3"
    
    var codes: [String] {
        switch self {
        case .one: return ["50", "51"]
        case .two: return ["55", "99"]
        case .three: return ["70", "77"]
        }
    }
}

protocol SignInViewDelegate: AnyObject {
    func didTapGetVerificationCode(operatorValue: String, number: String)
}

final class SignInView: UIView {
    
    weak var delegate: SignInViewDelegate?
    
    private var selectedOperator: OperatorValue = .one {
        didSet {
            updateCodePicker()
        }
    }
    private var selectedCodeIndex: Int = 0
    
    private var selectedCode: String {
        return selectedOperator.codes[selectedCodeIndex]
    }
    
    private let operatorSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: OperatorValue.allCases.map { $0.rawValue })
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let codePicker: UIPickerView = UIPickerView()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Number"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let getVerificationCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Verification Code", for: .normal)
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
        updateCodePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(self.operatorSegmentedControl)
        addSubview(self.codePicker)
        addSubview(self.numberTextField)
        addSubview(self.getVerificationCodeButton)
        
        self.codePicker.delegate = self
        self.codePicker.dataSource = self
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        self.operatorSegmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.codePicker.snp.makeConstraints { make in
            make.top.equalTo(self.operatorSegmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.numberTextField.snp.makeConstraints { make in
            make.top.equalTo(self.codePicker.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.getVerificationCodeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(58)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        self.operatorSegmentedControl.addTarget(self, action: #selector(self.operatorChanged), for: .valueChanged)
        self.getVerificationCodeButton.addTarget(self, action: #selector(self.getVerificationCodeTapped), for: .touchUpInside)
    }
    
    @objc private func operatorChanged() {
        let index = self.operatorSegmentedControl.selectedSegmentIndex
        self.selectedOperator = OperatorValue.allCases[index]
        self.selectedCodeIndex = 0
        self.numberTextField.text = self.selectedCode
    }
    
    @objc private func getVerificationCodeTapped() {
        let number = (numberTextField.text ?? "")
        
        if let delegate = self.delegate {
            delegate.didTapGetVerificationCode(operatorValue: self.selectedOperator.rawValue, number: number)
        }
    }
    
    private func updateCodePicker() {
        self.codePicker.reloadAllComponents()
        self.codePicker.selectRow(selectedCodeIndex, inComponent: 0, animated: false)
        self.numberTextField.text = self.selectedCode 
    }
}

extension SignInView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.selectedOperator.codes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.selectedOperator.codes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCodeIndex = row
        let selectedCode = self.selectedOperator.codes[row]
        self.numberTextField.text = selectedCode
    }
}
