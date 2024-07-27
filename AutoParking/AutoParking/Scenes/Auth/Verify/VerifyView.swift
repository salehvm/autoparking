//
//  VerifyView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import SnapKit

protocol VerifyViewDelegate: AnyObject {
    func didTapVerifyOTP(otp: String)
    func didTapResendOTP()
}

final class VerifyView: UIView {
    
    weak var delegate: VerifyViewDelegate?
    
    private var otpStackView: UIStackView!
    private var otpTextFields: [UITextField] = []
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "OTP təsdiqləmə"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    let verifyOTPButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Təsdiqlə", for: .normal)
        button.backgroundColor = UIColor(hex: "ECEEF4")
        button.setTitleColor(UIColor(hex: "000830"), for: .normal)
        button.layer.cornerRadius = 22
        button.isEnabled = false
        return button
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Daxil etdiyiniz OTP yanlışdır."
        label.textColor = UIColor.init(hex: "E5484D")
        label.isHidden = true
        return label
    }()
    
    private let resendOTPLabel: UILabel = {
        let label = UILabel()
        label.text = "Kodu qəbul etmədiniz?"
        label.textColor = .black
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "02:00"
        label.textColor = .blue
        return label
    }()
    
    private let resendOTPButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kodu yenidən göndər", for: .normal)
        button.setTitleColor(UIColor(hex: "0090FF"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var timer: Timer?
    private var secondsRemaining: Int = 120
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        setupActions()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let otpCount = 6
        otpStackView = UIStackView()
        otpStackView.axis = .horizontal
        otpStackView.distribution = .fillEqually
        otpStackView.spacing = 15
        
        for _ in 0..<otpCount {
            let textField = createOTPTextField()
            otpTextFields.append(textField)
            otpStackView.addArrangedSubview(textField)
        }
        
        addSubview(title)
        addSubview(subTitle)
        addSubview(otpStackView)
        addSubview(verifyOTPButton)
        addSubview(messageLabel)
        addSubview(resendOTPLabel)
        addSubview(timerLabel)
        addSubview(resendOTPButton)
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        
        self.title.snp.updateConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        self.subTitle.snp.updateConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        otpStackView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitle.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(27)
            make.trailing.equalToSuperview().offset(-27)
        }
        
        verifyOTPButton.snp.makeConstraints { make in
            make.top.equalTo(otpStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.height.equalTo(48)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyOTPButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        resendOTPLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(-20)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(resendOTPLabel)
            make.leading.equalTo(resendOTPLabel.snp.trailing).offset(4)
        }
        
        resendOTPButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        verifyOTPButton.addTarget(self, action: #selector(verifyOTPTapped), for: .touchUpInside)
        resendOTPButton.addTarget(self, action: #selector(resendOTPTapped), for: .touchUpInside)
        
        for textField in otpTextFields {
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    private func createOTPTextField() -> UITextField {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.font = .boldSystemFont(ofSize: 24)
        textField.layer.cornerRadius = 22
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.init(hex: "D9D9D9").cgColor
        textField.backgroundColor = UIColor.init(hex: "FBFDFF")
        textField.textColor = .black
        textField.delegate = self
        return textField
    }
    
    @objc private func verifyOTPTapped() {
        let otp = otpTextFields.compactMap { $0.text }.joined()
        
        if let delegate = self.delegate {
            delegate.didTapVerifyOTP(otp: otp)
        }
    }
    
    @objc private func resendOTPTapped() {
        if let delegate = self.delegate {
            delegate.didTapResendOTP()
        }
        startTimer()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count > 1 {
            textField.text = String(text.prefix(1))
        }
        
        if textField.text?.isEmpty == false {
            if let nextField = otpTextFields.first(where: { $0.text?.isEmpty ?? true }) {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if textField.text?.isEmpty == true {
            if let previousFieldIndex = otpTextFields.firstIndex(of: textField), previousFieldIndex > 0 {
                otpTextFields[previousFieldIndex - 1].becomeFirstResponder()
            }
        }
        
        updateTextFieldAppearance()
        updateVerifyButtonState()
    }
    
    private func updateTextFieldAppearance() {
        for textField in otpTextFields {
            if let text = textField.text, !text.isEmpty {
                textField.layer.borderColor = UIColor(hex: "0090FF").cgColor
                textField.backgroundColor = UIColor(hex: "0090FF").withAlphaComponent(0.3)
                textField.textColor = UIColor(hex: "0090FF")
            } else {
                textField.layer.borderColor = UIColor.init(hex: "D9D9D9").cgColor
                textField.backgroundColor = UIColor.init(hex: "FBFDFF")
                textField.textColor = .black
            }
        }
    }
    
    private func updateVerifyButtonState() {
        let isOTPComplete = otpTextFields.allSatisfy { $0.text?.isEmpty == false }
        verifyOTPButton.isEnabled = isOTPComplete
        
        if isOTPComplete {
            verifyOTPButton.backgroundColor = UIColor(hex: "0090FF")
            verifyOTPButton.setTitleColor(.white, for: .normal)
        } else {
            verifyOTPButton.backgroundColor = UIColor(hex: "ECEEF4")
            verifyOTPButton.setTitleColor(UIColor(hex: "000830"), for: .normal)
        }
    }
    
    private func startTimer() {
        secondsRemaining = 120
        resendOTPButton.isHidden = true
        timerLabel.isHidden = false
        resendOTPLabel.isHidden = false
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            let minutes = String(format: "%02d", secondsRemaining / 60)
            let seconds = String(format: "%02d", secondsRemaining % 60)
            timerLabel.text = "\(minutes):\(seconds)"
        } else {
            timer?.invalidate()
            resendOTPButton.isHidden = false
            timerLabel.isHidden = true
            resendOTPLabel.isHidden = true
        }
    }
    
    func updateMessage(_ message: String, isError: Bool) {
        messageLabel.text = message
        messageLabel.textColor = isError ? UIColor.init(hex: "E5484D") : .black
        messageLabel.isHidden = false
        
        if isError {
            for textField in otpTextFields {
                textField.layer.borderColor = UIColor.init(hex: "E5484D").cgColor
                textField.backgroundColor = UIColor.init(hex: "E5484D").withAlphaComponent(0.3)
                textField.textColor = UIColor.init(hex: "E5484D")
            }
        } else {
            updateTextFieldAppearance()
        }
    }
}

extension VerifyView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.messageLabel.isHidden = true
        
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
}
