//
//  VerifyView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import SnapKit
import AutoParkingUIKit

protocol VerifyViewDelegate: AnyObject {
    func didTapVerifyOTP(otp: String)
}

final class VerifyView: UIView {
    
    weak var delegate: VerifyViewDelegate?
    
    private let otpTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter OTP"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let verifyOTPButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify OTP", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(otpTextField)
        addSubview(verifyOTPButton)
        addSubview(messageLabel)
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        otpTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.verifyOTPButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(58)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyOTPButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        verifyOTPButton.addTarget(self, action: #selector(verifyOTPTapped), for: .touchUpInside)
    }
    
    @objc private func verifyOTPTapped() {
        let otp = otpTextField.text ?? ""
        
        if let delegate = self.delegate {
            delegate.didTapVerifyOTP(otp: otp)
        }
    }
    
    func updateMessage(_ message: String) {
        messageLabel.text = message
    }
}
