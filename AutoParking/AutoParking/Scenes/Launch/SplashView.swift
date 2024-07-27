//
//  SplashView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingUIKit

protocol SplashViewDelegate: AnyObject {}

final class SplashView: UIView, ThemeableView {
    
    weak var delegate: SplashViewDelegate?
    var theme: ThemeProvider = App.theme
    
    // MARK: - View Components
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        self.setupConstraints()
        super.updateConstraints()
    }
    
    // MARK: - Private
    private func addSubviews() {
        self.addSubview(self.logoImageView)
        self.setNeedsUpdateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    private func setupConstraints() {
        self.logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100) // or use appropriate size
        }
    }
}
