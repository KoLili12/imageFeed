//
//  GradientView.swift
//  imageFeed
//
//  Created by Николай Жирнов on 02.12.2024.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    
    // MARK: - @IBInspectable properties
    
    @IBInspectable public var topColor: UIColor = UIColor.clear
    @IBInspectable public var bottomColor: UIColor = UIColor(named: "YP Background (iOS)") ?? UIColor.black
    
    // MARK: - Private properties
    
    private let startPointX: CGFloat = 0.5
    private let startPointY: CGFloat = 0
    private let endPointX: CGFloat = 0.5
    private let endPointY: CGFloat = 1
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
