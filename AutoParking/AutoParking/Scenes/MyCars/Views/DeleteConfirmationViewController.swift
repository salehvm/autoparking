//
//  DeleteConfirmationViewController.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/07/2024.
//

import UIKit

protocol DeleteConfirmationDelegate: AnyObject {
    func didConfirmDeletion(vehicleId: String)
}

class DeleteConfirmationViewController: UIViewController {
    
    var vehicleId: String?
    weak var delegate: DeleteConfirmationDelegate?
    
    let confirmationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.init(hex: "1C2024")
        label.text = "Seçilən avtomobili siyahıdan silmək istədiyinə əminsən?"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Bunu etmək istədiyinə əminsən?"
        label.textColor = UIColor.init(hex: "52575C")
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Xeyr", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Bəli", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        containerView.addSubview(confirmationLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
        
        
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 150),
            
            confirmationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            confirmationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            confirmationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            confirmButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmButtonTapped() {
        if let vehicleId = vehicleId {
            delegate?.didConfirmDeletion(vehicleId: vehicleId)
        }
        dismiss(animated: true, completion: nil)
    }
}
