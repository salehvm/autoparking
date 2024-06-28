//
//  Cell+Configurer.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit

protocol CellConfigurer: AnyObject {
    static var reuseIdentifier: String {get}
}

extension CellConfigurer {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellConfigurer { }
extension UICollectionViewCell: CellConfigurer { }
