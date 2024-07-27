//
//  EdirDeviceNameSheet.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import AutoParkingUIKit
import SnapKit

final class EdirDeviceNameSheet: UIViewController, ThemeableViewController {

    var theme: ThemeProvider = App.theme
    
    private var selectCompletion: (String) -> Void = { _ in  }
    
    // MARK: - View Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Düzəliş et"
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
    
    private lazy var deviceLabel: UILabel = {
        let label = UILabel()
        label.text = "Blutuzun adı:"
        label.textColor = UIColor.init(hex: "1C2024")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 24
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yadda saxla", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.init(hex: "0090FF")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(saveButtonTouchUp), for: .touchUpInside)
        return button
    }()
    
    @objc var dismissCompletion: (() -> Void)?
   
    // MARK: - Init Methods
    
    init(deviceName: String, selectCompletion: @escaping (String) -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.selectCompletion = selectCompletion
        self.editTextField.text = deviceName
        hideKeyboardWhenTappedAround()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubviews()
        self.setupUI()
    }
    
    override func updateViewConstraints() {
        
        self.titleLabel.snp.updateConstraints { make in
            make.top.equalTo(22)
            make.leading.equalTo(16)
        }
        
        self.closeButton.snp.updateConstraints { make in
            make.top.equalTo(20)
            make.trailing.equalTo(-16)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        self.lineView.snp.updateConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.deviceLabel.snp.updateConstraints { make in
            make.top.equalTo(self.lineView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.editTextField.snp.updateConstraints { make in
            make.top.equalTo(self.deviceLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
       
        self.saveButton.snp.updateConstraints { make in
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.lineView)
        
        self.view.addSubview(self.deviceLabel)
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
            self.selectCompletion(self.editTextField.text ?? "")
        }
    }
}
