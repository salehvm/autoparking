//
//  OnboardingItemView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit
import AutoParkingUIKit
import Lottie

final class OnboardingItemView: UIView, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    // MARK: - View Components
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: "211F26")
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dynamicLottieImage: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    init(lottieName: String?, title: String) {
        super.init(frame: .zero)
        
        self.dynamicLottieImage.animation = LottieAnimation.named(lottieName ?? "")
        self.titleLabel.text = title
        
        self.addSubviews()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update constraints & add
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.snp.updateConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 46)
        }
        
        self.textStackView.snp.updateConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.dynamicLottieImage.snp.updateConstraints { make in
            make.top.equalTo(self.textStackView.snp.bottom).offset(72)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(280)
        }
        
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        self.addSubview(self.textStackView)
        self.addSubview(self.dynamicLottieImage)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.dynamicLottieImage.play()
    }
}

