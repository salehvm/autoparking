//
//  OnboardingView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 27/07/2024.
//

import UIKit
import AutoParkingUIKit

protocol OnboardingViewDelegate: AnyObject {
    func viewSignInClick()
}

final class OnboardingView: UIView, ThemeableView {
    
    // MARK: - Delegation
    
    weak var delegate: OnboardingViewDelegate?
    var theme: ThemeProvider = App.theme
    
    // MARK: - Data Onboarding
    
    private let items = [
        OnboardingItemView(lottieName: "onboardingLottieOne", title: "Park etməyə və dayandırmağa nəzarət etmək çətin gəlir?"),
        OnboardingItemView(lottieName: "onboardingLottieTwo", title: "Avtomobilini əlavə et, ParkinGo gerisini həll edəcək!"),
        OnboardingItemView(lottieName: "onboardingLottieThree", title: "ParkinGo ilə gözlənilməyən xərclərdən xilas ol")]
    
    
    // MARK: - View Components
    
    private lazy var progressBar: SegmentedProgressBar = {
        let progressBar = SegmentedProgressBar(numberOfSegments: 3, duration: 5)
        progressBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 2)
        progressBar.delegate = self
        progressBar.topColor = UIColor.init(hex: "0090FF")
        progressBar.bottomColor = UIColor.init(hex: "00051D").withAlphaComponent(0.2)
        progressBar.padding = 2
        progressBar.layer.cornerRadius = 2
        return progressBar
    }()
    
    private lazy var dynamicView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var visibleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var leftView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftViewTapped)))
        return view
    }()

    private lazy var rightView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightViewTapped)))
        return view
    }()

    private lazy var midView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(tappedView)))
        return view
    }()
    
//    private lazy var buttonStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 12
//        return stackView
//    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Daxil ol", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.init(hex: "0090FF")
        button.layer.cornerRadius = 24
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signInAction)))
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
        
        self.progressBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(2)
        }
        
        
        self.visibleStackView.snp.updateConstraints { make in
            make.bottom.equalTo(self.signInButton.snp.top).offset(-16)
            make.top.equalTo(self.progressBar.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.leftView.snp.updateConstraints { make in
            make.width.equalTo(90)
        }

        self.rightView.snp.updateConstraints { make in
            make.width.equalTo(90)
        }
        
        self.dynamicView.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.progressBar.snp.bottom).offset(64)
            make.bottom.equalTo(self.signInButton.snp.top).offset(-10)
        }
        
        self.signInButton.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-22)
            make.height.equalTo(48)
        }
        
        super.updateConstraints()
    }
    
    
    // MARK: - Private
    
    private func addSubviews() {
        self.addSubview(self.progressBar)
        
        self.addSubview(self.dynamicView)
//        self.addSubview(self.buttonStackView)
        
        self.visibleStackView.addArrangedSubview(self.leftView)
        self.visibleStackView.addArrangedSubview(self.midView)
        self.visibleStackView.addArrangedSubview(self.rightView)
        
        self.addSubview(self.visibleStackView)
        self.addSubview(self.signInButton)
//        self.buttonStackView.addArrangedSubview(self.signInButton)
        
        self.updateData(index: 0)
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        progressBar.startAnimation()
    }
    
    private func updateData(index: Int) {
        self.dynamicView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.dynamicView.addSubview(self.items[index])
    }
    
    
    // MARK: - View Tap gestures
    
    @objc func leftViewTapped() {
        progressBar.rewind()
    }
    
    @objc func rightViewTapped() {
        progressBar.skip()
    }
    
    @objc func tappedView(sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 0.1
        progressBar.isPaused = !progressBar.isPaused
    }
    
    
    // MARK: - Buttons Action
    
    @objc func signInAction() {
        if let delegate = self.delegate {
            delegate.viewSignInClick()
        }
    }
}

// MARK: - SegmentedProgressBar Delegate

extension OnboardingView: SegmentedProgressBarDelegate {
    
    func segmentedProgressBarChangedIndex(index: Int) {
        updateData(index: index)
    }
        
    func segmentedProgressBarFinished() {
        
    }
}
