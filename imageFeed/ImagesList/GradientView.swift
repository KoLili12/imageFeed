//
//  GradientView.swift
//  imageFeed
//
//  Created by Николай Жирнов on 02.12.2024.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable public var topColor: UIColor = UIColor.clear
    @IBInspectable public var bottomColor: UIColor = UIColor(named: "YP Background (iOS)") ?? UIColor.black
    
    var startPointX: CGFloat = 0.5
    var startPointY: CGFloat = 0
    var endPointX: CGFloat = 0.5
    var endPointY: CGFloat = 1
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
