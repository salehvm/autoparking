//
//  GetInfoAutoPilotModal.swift
//  AutoParking
//
//  Created by Saleh Majidov on 28/07/2024.
//

import UIKit
import Lottie
import SnapKit

protocol GetInfoAutoPilotModalDelegate: AnyObject {
    func dismissCompletion()
}

class GetInfoAutoPilotModal: UIViewController {
    
    weak var delegate: GetInfoAutoPilotModalDelegate?

    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouchUp), for: .touchUpInside)
    
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#113264")
        label.text = "Servisi aktiv edərkən sizin yerinizə park avtomatik ediləcək"
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infoAnimation: LottieAnimationView = {
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named("infoanimation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        self.view.addSubview(self.bodyView)
        self.bodyView.addSubview(self.infoLabel)
        self.bodyView.addSubview(self.closeButton)
        self.bodyView.addSubview(self.infoAnimation)
    }
    
    private func setupUI() {
        infoAnimation.play()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func setupConstraints() {
        
        self.bodyView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(400)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.bodyView.snp.top).offset(16)
            make.trailing.equalTo(self.bodyView.snp.trailing).offset(-16)
            make.width.height.equalTo(40)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.bodyView.snp.bottom).inset(40)
            make.leading.equalTo(self.bodyView.snp.leading).offset(16)
            make.trailing.equalTo(self.bodyView.snp.trailing).offset(-16)
        }
        
        self.infoAnimation.snp.makeConstraints { make in
            make.top.equalTo(self.closeButton.snp.bottom)
            make.centerX.equalTo(self.bodyView.snp.centerX)
            make.width.height.equalTo(350)
        }
    }
    
    @objc func closeButtonTouchUp() {
        dismiss(animated: true) {
            self.delegate?.dismissCompletion()
        }
    }
}
