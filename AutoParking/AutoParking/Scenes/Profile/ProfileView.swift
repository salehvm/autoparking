//
//  ProfileView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func logout()
    func manageAutoSwcViewChange(_ isOn: Bool)
}

final class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private lazy var number: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: 96.0, height: 152.0)
        layout.sectionInset = .init(top: 0, left: 16, bottom: 24, right: 16)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.clipsToBounds = false
        collectionView.register(PaymentCardCell.self, forCellWithReuseIdentifier: PaymentCardCell.reuseIdentifier)
        return collectionView
    }()
    
    lazy var switchBtn: UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.addTarget(self, action: #selector(stateChange(_:)), for: .valueChanged)
        return switchBtn
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        button.layer.cornerRadius = 12
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
        
        self.userName.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        self.number.snp.updateConstraints { make in
            make.top.equalTo(self.userName.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        self.collectionView.snp.updateConstraints { make in
            make.top.equalTo(self.number.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        self.switchBtn.snp.updateConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.collectionView.snp.bottom).offset(16)
        }
        
        self.logoutButton.snp.updateConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(250)
            make.bottom.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.addSubview(self.userName)
        self.addSubview(self.number)
        self.addSubview(self.collectionView)
        self.addSubview(self.switchBtn)
        self.addSubview(self.logoutButton)
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        let session = SessionManager.shared
        
        self.userName.text = "\(session.user?.firstname ?? "") \(session.user?.lastname ?? "")"
        self.number.text = session.user?.msisdn ?? ""
    }
    
    @objc func stateChange(_ swc: UISwitch) {
        if let delegate = delegate {
            delegate.manageAutoSwcViewChange(swc.isOn)
        }
    }
    
    @objc func logoutAction() {
        if let delegate = self.delegate {
            delegate.logout()
        }
    }
}
