//
//  PermissionAuthView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/07/2024.
//

import UIKit
import Lottie
import SnapKit

protocol PermissionAuthViewDelegate: AnyObject {
    func getLocation()
    func cancelLocation()
}

final class PermissionAuthView: UIView {
    
    weak var delegate: PermissionAuthViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Yerinizə daxil olmağa icazə verin"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.text = "Bu tətbiqi istifadə edə bilməyin üçün yerinizə daxil olmağa icazə verməlisiniz"
        label.textColor = UIColor.init(hex: "113264")
        return label
    }()
    
    private lazy var locIcon: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        if let animation = LottieAnimation.named("locationLottie") {
            animationView.animation = animation
        } else {
            print("Error: Lottie animation file not found.")
        }
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
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
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hex: "000000"), for: .normal)
        button.setTitle("İndi yox", for: .normal)
        button.addTarget(self, action: #selector(cancelLocPermission), for: .touchUpInside)
        button.layer.cornerRadius = 24
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubviews()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        self.locIcon.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(48)
            make.height.width.equalTo(500)
            make.centerX.equalToSuperview()
        }
        
        self.permissionBtn.snp.makeConstraints { make in
            make.top.equalTo(self.locIcon.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(48)
        }
        
        self.cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(self.permissionBtn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(48)
        }
        
        super.updateConstraints()
    }
    
    @objc private func getLocPermission() {
        delegate?.getLocation()
    }
    
    @objc private func cancelLocPermission() {
        delegate?.cancelLocation()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(locIcon)
        addSubview(permissionBtn)
        addSubview(cancelBtn)
        setNeedsUpdateConstraints()
    }
    
    private func setupUI() {
        locIcon.play()
        backgroundColor = .white
    }
}
