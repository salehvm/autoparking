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

final class BookedListCell: UITableViewCell, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    var data: Booking? {
        didSet {
            self.configure()
        }
    }
    
    private lazy var bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
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
            make.edges.equalToSuperview()
            make.height.equalTo(350)
        }
        
        self.titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    deinit {
        self.data = nil
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.bodyView.addSubview(self.titleLabel)
        
        self.contentView.addSubview(self.bodyView)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    private func configure() {
        if let data = self.data {
            self.titleLabel.text = data.car?.number
        }
    }
}

