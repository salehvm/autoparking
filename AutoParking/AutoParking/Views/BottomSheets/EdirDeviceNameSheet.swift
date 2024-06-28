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
        label.text = "Edit device name"
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
    
    private lazy var editTextField: UITextField = {
        let textField = UITextField()
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
            make.top.equalTo(8)
            make.trailing.equalTo(-8)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        self.lineView.snp.updateConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.editTextField.snp.updateConstraints { make in
            make.top.equalTo(self.lineView.snp.bottom).offset(16)
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
