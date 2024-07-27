//
//  ProfileView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func logout()
    func manageAutoSwcViewChange(_ isOn: Bool)
    func getLocation()
}

final class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profil"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor(hex: "113264")
        return label
    }()
    
    lazy var switchView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ACD8FC").withAlphaComponent(0.1)
        view.layer.borderColor = UIColor(hex: "ACD8FC").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var switchTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = UIColor(hex: "113264")
        label.text = "Autopilot"
        return label
    }()
    
    private lazy var switchInfoButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "Lorem ipsum dolor sit amet"
        config.image = UIImage(named: "info_icon")
        config.imagePadding = 8
        config.baseForegroundColor = UIColor(hex: "0D74CE")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        button.configuration = config
        return button
    }()
    
    lazy var switchBtn: UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.onTintColor = UIColor(hex: "0090FF")
        switchBtn.addTarget(self, action: #selector(stateChange(_:)), for: .valueChanged)
        return switchBtn
    }()
    
    lazy var bankCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ACD8FC").withAlphaComponent(0.1)
        view.layer.borderColor = UIColor(hex: "ACD8FC").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var cardTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = UIColor(hex: "113264")
        label.text = "Aktiv bank kartın"
        return label
    }()
    
    lazy var cardNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(hex: "113264")
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "Çıxış et"
        config.image = UIImage(named: "logout_icon")
        config.imagePadding = 8
        config.baseForegroundColor = UIColor(hex: "CE2C31")
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(hex: "CE2C31").cgColor
        return button
    }()
    
    lazy var locPermissionView: GlobalLocationPermissionView = {
        let view = GlobalLocationPermissionView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .white
        
    }
    
    override func updateConstraints() {
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview().inset(28)
        }

        self.switchView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(84)
        }

        self.switchTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
        }

        self.switchInfoButton.snp.makeConstraints { make in
            make.top.equalTo(self.switchTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(10)
        }

        self.switchBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.equalTo(42)
            make.height.equalTo(24)
        }

        self.bankCardView.snp.makeConstraints { make in
            make.top.equalTo(self.switchView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(84)
        }

        self.cardTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
        }

        self.cardNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cardTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
        }

        self.logoutButton.snp.makeConstraints { make in
            make.top.equalTo(self.bankCardView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
        
        self.locPermissionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
        
        super.updateConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(self.locPermissionView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.switchView)
        
        self.switchView.addSubview(self.switchTitle)
        self.switchView.addSubview(self.switchInfoButton)
        self.switchView.addSubview(self.switchBtn)
        self.addSubview(self.bankCardView)
        self.bankCardView.addSubview(self.cardTitle)
        self.bankCardView.addSubview(self.cardNumberLabel)
        self.addSubview(self.logoutButton)
        
        self.updateConstraints()
    }
    
    @objc private func stateChange(_ swc: UISwitch) {
        delegate?.manageAutoSwcViewChange(swc.isOn)
    }
    
    @objc private func logoutAction() {
        delegate?.logout()
    }
}

extension ProfileView: GlobalLocationPermissionViewDelegate {
    
    func getLocation() {
        if let delegate = self.delegate {
            delegate.getLocation()
        }
    }
}
