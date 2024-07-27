//
//  SelectCarBottomSheet.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit
import SnapKit
import AutoParkingUIKit
import AutoParkingNetwork

final class SelectCarBottomSheet: UIViewController, ThemeableViewController {

    var theme: ThemeProvider = App.theme
    
    private var selectCompletion: (Vehicle) -> Void = { _ in }
    
    private var selectedCarIndex: Int = 0
    private var selectedCar: Vehicle?
    
    var cars: [Vehicle] = [] {
        didSet {
            self.carPicker.reloadAllComponents()
            if !cars.isEmpty {
                self.carPicker.selectRow(selectedCarIndex, inComponent: 0, animated: false)
                self.selectedCar = cars[selectedCarIndex]
            }
        }
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
    
    let carPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    @objc var dismissCompletion: (() -> Void)?
   
    // MARK: - Init Methods
    
    init(cars: [Vehicle], selectCompletion: @escaping (Vehicle) -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.selectCompletion = selectCompletion
        self.cars = cars
        self.carPicker.delegate = self
        self.carPicker.dataSource = self
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
        
        self.carPicker.snp.makeConstraints { make in
            make.top.equalTo(self.lineView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.view.addSubview(self.cancelBtn)
        self.view.addSubview(self.confirmBtn)
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.carPicker)
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

            if self.selectedCar == nil, !self.cars.isEmpty {
                self.selectedCar = self.cars.first
            }

            if let selectCar = self.selectedCar {
                self.selectCompletion(selectCar)
            }
        }
    }

    
    private func updateCodePicker() {
        self.carPicker.reloadAllComponents()
        self.carPicker.selectRow(selectedCarIndex, inComponent: 0, animated: false)
    }
}

extension SelectCarBottomSheet: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
