//
//  SignInView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingUIKit
import SnapKit

protocol SignInViewDelegate: AnyObject {
    func didTapGetVerificationCode(number: String)
    func callPrefixBottom()
}

final class SignInView: UIView {
    
    weak var delegate: SignInViewDelegate?
    
    private lazy var logoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "parkingo_auth")
        return imageView
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Parkinq prosesini sürətləndirmək üçün sizə dəstək olacağıq!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var prefixView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "00062E").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var prefixLabel: UILabel = {
        let label = UILabel()
        label.text = "Prefiks"
        label.textColor = UIColor(hex: "00071B")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var prefixIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron-down")
        return imageView
    }()
    
    private lazy var numberView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "00062E").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.placeholder = "xxx xx xx"
        return textField
    }()
    
    private let getVerificationCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Daxil ol", for: .normal)
        button.backgroundColor = UIColor(hex: "ECEEF4")
        button.isEnabled = false
        button.setTitleColor(UIColor(hex: "000830"), for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(getVerificationCodeTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
        numberTextField.delegate = self
        
        self.prefixView.addTapGesture {
            if let delegate = self.delegate {
                delegate.callPrefixBottom()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.addSubview(self.logoIcon)
        self.addSubview(self.descLabel)
        
        self.addSubview(self.hStackView)
        
        self.hStackView.addArrangedSubview(self.prefixView)
        self.hStackView.addArrangedSubview(self.numberView)
        
        self.prefixView.addSubview(self.prefixIcon)
        self.prefixView.addSubview(self.prefixLabel)
        
        self.numberView.addSubview(self.numberTextField)
        
        self.addSubview(self.getVerificationCodeButton)
        
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        
        self.logoIcon.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(168)
            make.height.equalTo(38)
            make.centerX.equalToSuperview()
        }
        
        self.descLabel.snp.updateConstraints { make in
            make.top.equalTo(self.logoIcon.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.height.equalTo(52)
        }
        
        self.hStackView.snp.updateConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(self.descLabel.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
        }
        
        self.prefixView.snp.updateConstraints { make in
            make.width.equalTo(114)
        }
        
        self.prefixLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(52)
        }
        
        self.prefixIcon.snp.updateConstraints { make in
            make.leading.equalTo(self.prefixLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        
        self.numberTextField.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        self.getVerificationCodeButton.snp.makeConstraints { make in
            make.top.equalTo(self.hStackView.snp.bottom).offset(42)
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.height.equalTo(48)
        }
    }
    
    @objc private func getVerificationCodeTapped() {
        let number = (numberTextField.text ?? "")
        delegate?.didTapGetVerificationCode(number: number)
    }
    
    private func updateButtonState() {
        let text = numberTextField.text ?? ""
        let isEnabled = !text.isEmpty
        getVerificationCodeButton.isEnabled = isEnabled
        if isEnabled {
            getVerificationCodeButton.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
            getVerificationCodeButton.backgroundColor = UIColor(hex: "0090FF")
        } else {
            getVerificationCodeButton.setTitleColor(UIColor(hex: "000830"), for: .normal)
            getVerificationCodeButton.backgroundColor = UIColor(hex: "ECEEF4")
        }
    }
}

extension SignInView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        updateButtonState()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateButtonState()
    }
}
