//
//  BookedListCell.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import SnapKit
import AutoParkingUIKit
import AutoParkingNetwork
import Lottie

final class BookedListCell: UITableViewCell, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    var data: Booking? {
        didSet {
            self.configure()
            self.updateCountdown()
        }
    }
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "ACD8FC").withAlphaComponent(0.1)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "ACD8FC").cgColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var carImage: LottieAnimationView = {
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named("activePark")
        animationView.animation = animation
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = UIColor(hex: "113264")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lineViewOne: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "E2E4E4")
        return view
    }()
    
    private lazy var parkCode: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "0588F0")
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var streetParkCode: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "0588F0")
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lineViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "E2E4E4")
        return view
    }()
    
    private lazy var startDateView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var clockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock_icon_active")
        return imageView
    }()
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Başlama vaxtı:"
        label.textColor = UIColor(hex: "30A46C")
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var startDateTime: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "30A46C")
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var countdownView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "D5EFFF")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "8EC8F6").cgColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var daysStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.daysLabel, self.daysTextLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var hoursStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.hoursLabel, self.hoursTextLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var minutesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.minutesLabel, self.minutesTextLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var secondsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.secondsLabel, self.secondsTextLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var countdownStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.daysStackView, self.hoursStackView, self.minutesStackView, self.secondsStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "00"
        return label
    }()
    
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "00"
        return label
    }()
    
    private lazy var minutesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "00"
        return label
    }()
    
    private lazy var secondsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "00"
        return label
    }()
    
    private lazy var daysTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "Gün"
        return label
    }()
    
    private lazy var hoursTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "Saat"
        return label
    }()
    
    private lazy var minutesTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "Dəqiqə"
        return label
    }()
    
    private lazy var secondsTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "113264")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "Saniyə"
        return label
    }()
    
    private var timer: Timer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews()
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.data = nil
        self.timer?.invalidate()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.alpha = highlighted ? 0.6 : 1.0
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.carImage)
        self.bodyView.addSubview(self.titleLabel)
        self.bodyView.addSubview(self.lineViewOne)
        self.bodyView.addSubview(self.parkCode)
        self.bodyView.addSubview(self.streetParkCode)
        self.bodyView.addSubview(self.lineViewTwo)
        self.bodyView.addSubview(self.startDateView)
        self.startDateView.addSubview(self.clockIcon)
        self.startDateView.addSubview(self.startDateLabel)
        self.startDateView.addSubview(self.startDateTime)
        self.bodyView.addSubview(self.countdownView)
        self.countdownView.addSubview(self.countdownStackView)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.carImage.play()
        self.selectionStyle = .none
        self.backgroundColor = .white
    }
    
    override func updateConstraints() {
        self.bodyView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
            make.height.equalTo(462)
        }
        
        self.carImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.width.equalTo(160)
            make.height.equalTo(92)
            make.centerX.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.carImage.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.lineViewOne.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(1)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.centerX.equalTo(self.titleLabel)
        }
        
        self.parkCode.snp.makeConstraints { make in
            make.top.equalTo(self.lineViewOne.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.streetParkCode.snp.makeConstraints { make in
            make.top.equalTo(self.parkCode.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.lineViewTwo.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(1)
            make.top.equalTo(self.streetParkCode.snp.bottom).offset(24)
            make.centerX.equalTo(self.titleLabel)
        }
        
        self.startDateView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(230)
            make.centerX.equalTo(self.lineViewTwo.snp.centerX)
            make.top.equalTo(self.lineViewTwo.snp.bottom).offset(24)
        }
        
        self.clockIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
        }
        
        self.startDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.clockIcon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        self.startDateTime.snp.makeConstraints { make in
            make.leading.equalTo(self.startDateLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
        }
        
        self.countdownView.snp.makeConstraints { make in
            make.top.equalTo(self.startDateView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(68)
        }
        
        self.countdownStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        super.updateConstraints()
    }
    
    private func configure() {
        if let data = self.data {
            self.titleLabel.text = data.car?.number
            self.parkCode.text = data.park?.code
            self.streetParkCode.text = data.park?.address
            self.startDateTime.text = data.startDate
        }
    }
    
    private func updateCountdown() {
        guard let startDateString = data?.startDate else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        guard let startDate = dateFormatter.date(from: startDateString) else {
            print("Failed to parse date from startDateString: \(startDateString)")
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let todayStartDate = calendar.date(bySettingHour: calendar.component(.hour, from: startDate),
                                           minute: calendar.component(.minute, from: startDate),
                                           second: calendar.component(.second, from: startDate),
                                           of: calendar.date(from: components)!)!
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let now = Date()
            
            if now >= todayStartDate {
                let countdownComponents = calendar.dateComponents([.hour, .minute, .second], from: todayStartDate, to: now)
                self.hoursLabel.text = String(format: "%02d", abs(countdownComponents.hour ?? 0))
                self.minutesLabel.text = String(format: "%02d", abs(countdownComponents.minute ?? 0))
                self.secondsLabel.text = String(format: "%02d", abs(countdownComponents.second ?? 0))
                print("Updating countdown: hours: \(countdownComponents.hour ?? 0), minutes: \(countdownComponents.minute ?? 0), seconds: \(countdownComponents.second ?? 0)")
            } else {
                self.hoursLabel.text = "00"
                self.minutesLabel.text = "00"
                self.secondsLabel.text = "00"
                self.timer?.invalidate()
            }
        }
    }
    
    deinit {
        self.timer?.invalidate()
        self.data = nil
    }
}
