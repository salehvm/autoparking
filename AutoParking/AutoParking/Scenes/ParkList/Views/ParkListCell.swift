//
//  ParkListCell.swift
//  AutoParking
//
//  Created by Saleh Majidov on 25/06/2024.
//

import UIKit
import SnapKit
import AutoParkingUIKit
import AutoParkingNetwork

final class ParkListCell: UITableViewCell, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    var data: Park? {
        didSet {
            self.configure()
        }
    }
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var streetName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var code: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .systemGreen
        return label
    }()
    
    private lazy var location: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
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
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.alpha = highlighted ? 0.6 : 1.0
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        self.bodyView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        self.streetName.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
        }
        
        self.code.snp.updateConstraints { make in
            make.top.equalTo(self.streetName.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(8)
        }
        
        self.location.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
        }
    }
    
    deinit {
        self.data = nil
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.bodyView.addSubview(self.streetName)
        self.bodyView.addSubview(self.code)
        self.bodyView.addSubview(self.location)
        
        self.contentView.addSubview(self.bodyView)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func configure() {
        if let data = self.data {
            self.code.text = data.code
            self.streetName.text = data.address
            self.location.text = "\(data.distance ?? 0.0) \(data.distanceUnit ?? "")"
        }
    }
}


