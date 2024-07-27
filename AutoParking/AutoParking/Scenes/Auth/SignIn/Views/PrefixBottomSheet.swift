//
//  PrefixBottomSheet.swift
//  AutoParking
//
//  Created by Saleh Majidov on 22/07/2024.
//

import UIKit
import SnapKit
import AutoParkingUIKit

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
    
    static var allCodes: [String] {
        return OperatorValue.allCases.flatMap { $0.codes }
    }
    
    static func `operator`(for code: String) -> OperatorValue? {
        return OperatorValue.allCases.first { $0.codes.contains(code) }
    }
}

final class PrefixBottomSheet: UIViewController, ThemeableViewController {

    var theme: ThemeProvider = App.theme
    
    private var selectCompletion: (String, OperatorValue) -> Void = { _, _ in }
    
    private let codePicker: UIPickerView = UIPickerView()
    
    private var selectedCodeIndex: Int = 0
    
    private var selectedCode: String {
        return OperatorValue.allCodes[selectedCodeIndex]
    }
    
    private var selectedOperator: OperatorValue? {
        return OperatorValue.operator(for: selectedCode)
    }
    
    // MARK: - View Components
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouchUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTouchUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    @objc var dismissCompletion: (() -> Void)?
   
    // MARK: - Init Methods
    
    init(selectCompletion: @escaping (String, OperatorValue) -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.selectCompletion = selectCompletion
        
        self.codePicker.delegate = self
        self.codePicker.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSubviews()
        self.setupUI()
        
        self.updateCodePicker()
    }
    
    override func updateViewConstraints() {
        
        self.cancelBtn.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        self.confirmBtn.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        self.lineView.snp.updateConstraints { make in
            make.top.equalTo(self.cancelBtn.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.codePicker.snp.updateConstraints { make in
            make.top.equalTo(self.lineView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.view.addSubview(self.cancelBtn)
        self.view.addSubview(self.confirmBtn)
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.codePicker)
        
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
    
    @objc func confirmButtonTouchUp() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            if let selectedOperator = self.selectedOperator {
                self.selectCompletion(self.selectedCode, selectedOperator)
            }
        }
    }
    
    private func updateCodePicker() {
        self.codePicker.reloadAllComponents()
        self.codePicker.selectRow(selectedCodeIndex, inComponent: 0, animated: false)
    }
}

extension PrefixBottomSheet: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return OperatorValue.allCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return OperatorValue.allCodes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCodeIndex = row
        let selectedCode = OperatorValue.allCodes[row]
        if let selectedOperator = OperatorValue.operator(for: selectedCode) {
            self.selectCompletion(selectedCode, selectedOperator)
        }
    }
}
