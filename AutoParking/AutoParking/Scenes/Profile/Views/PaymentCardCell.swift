//
//  PaymentCardCell.swift
//  AutoParking
//
//  Created by Saleh Majidov on 26/06/2024.
//

import UIKit
import AutoParkingUIKit
import SnapKit

protocol PaymentCardCellDelegate: AnyObject {
    func addAddressCellButtonClick()
}

final class PaymentCardCell: UICollectionViewCell, ThemeableView {
    
    var theme: ThemeProvider = App.theme
    
    weak var delegate: PaymentCardCellDelegate?
    
    // MARK: - View Components
   
    lazy var bodyView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.systemGray2
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews()
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        self.bodyView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        self.title.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        self.contentView.addSubview(self.bodyView)
        
        self.bodyView.addSubview(self.title)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.contentView.backgroundColor = .clear
    }
    
}

