//
//  TabBarView.swift
//  AutoParking
//
//  Created by Saleh Majidov on 24/06/2024.
//

import UIKit
import AutoParkingUIKit

class AppTabBar: UITabBar, ThemeableView {
    var theme: ThemeProvider = App.theme
    
    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    //MARK: Init
    
    init() {
        super.init(frame: .zero)
        self.tintColor = UIColor.init(hex: "0D74CE")
        self.unselectedItemTintColor = .systemGray2
        self.backgroundColor = .clear
        self.isTranslucent = false
        self.barTintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.3
        shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
        shapeLayer.shadowRadius = 8
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    func createPath() -> CGPath {
        let radius: CGFloat = 8.0
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: radius, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: self.frame.width - radius, y: radius), radius: radius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
        
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height - radius))
        path.addArc(withCenter: CGPoint(x: self.frame.width - radius, y: self.frame.height - radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        
        path.addLine(to: CGPoint(x: radius, y: self.frame.height))
        path.addArc(withCenter: CGPoint(x: radius, y: self.frame.height - radius), radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        
        path.close()
        
        return path.cgPath
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 90 // Set the desired height
        return sizeThatFits
    }
}
