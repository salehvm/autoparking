//
//  GlobalLocationPermissionView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/07/2024.
//

import UIKit

protocol GlobalLocationPermissionViewDelegate: AnyObject {
    func getLocation()
}

final class GlobalLocationPermissionView: UIView {
    
    weak var delegate: GlobalLocationPermissionViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yerinizə daxil olmağa icazə verin"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor(hex: "113264")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Bu tətbiqi istifadə edə bilməyin üçün yerinizə daxil olmağa icazə verməlisiniz"
        label.textColor = UIColor(hex: "113264")
        return label
    }()
    
    private lazy var locIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location_icon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var permissionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        button.backgroundColor = UIColor(hex: "0090FF")
        button.setTitle("İcazə ver", for: .normal)
        button.addTarget(self, action: #selector(getLocPermission), for: .touchUpInside)
        button.layer.cornerRadius = 24
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        locIcon.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(48)
            make.size.equalTo(238)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        permissionBtn.snp.makeConstraints { make in
            make.top.equalTo(locIcon.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(48)
        }
        
        super.updateConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(locIcon)
        addSubview(permissionBtn)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    @objc private func getLocPermission() {
        print("tap")
        delegate?.getLocation()
    }
    
}
