//
//  ActiveParkingView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol ActiveParkingViewDelegate: AnyObject {
    
}

final class ActiveParkingView: UIView {
    
    weak var delegate: ActiveParkingViewDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(BookedListCell.self, forCellReuseIdentifier: BookedListCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.sectionFooterHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        return tableView
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
        
        self.tableView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-32)
        }
        
        super.updateConstraints()
    }
    
    
    // MARK: - Private
    
    private func addSubviews() {
        
        self.addSubview(self.tableView)
        
        self.updateConstraints()
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
}
