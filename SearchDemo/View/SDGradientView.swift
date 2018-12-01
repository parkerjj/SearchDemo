//
//  File.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/30/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation
import UIKit


enum SDGradientViewMoveDirection {
    case left
    case right
}


class SDGradientView: UIScrollView {
    private var _gLayer = CAGradientLayer()
    var gradientColors : [CGColor]?
    var displayLink : CADisplayLink?
    var direction = SDGradientViewMoveDirection.left
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override var contentOffset: CGPoint{
        willSet(newValue) {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        layoutGradientLayer()

    }
    
    
    
    
    @objc func layoutGradientLayer()  {
        if _gLayer.colors == nil {
            // First Add GradientLayer into View
            _gLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width*5, height: self.bounds.size.height)
            if (gradientColors != nil && _gLayer.colors == nil) {
                _gLayer.colors = []
                for _ in 0..<5 {
                    _gLayer.colors = _gLayer.colors! + (gradientColors!.reversed() + gradientColors!)
                }
//                _gLayer.colors =   + gradientColors!.reversed() + gradientColors! + gradientColors!.reversed() + gradientColors!
//                _gLayer.colors = _gLayer.colors  + gradientColors!.reversed() + gradientColors! + gradientColors!.reversed() + gradientColors!
            }
            _gLayer.startPoint = CGPoint(x: 0, y: 0)
            _gLayer.endPoint = CGPoint(x: 2, y: 0)
            self.layer.insertSublayer(_gLayer, at: 0)
        }
        
        
        let offset = self.contentOffset.x.truncatingRemainder(dividingBy: self.bounds.size.width*3)
        let pointX : CGFloat = self.contentOffset.x - self.bounds.size.width
        if (Int(offset.truncatingRemainder(dividingBy: self.bounds.size.width*2)) < 3){
            print("contentOffset \(self.contentOffset) Offset \(offset)  pointX \(pointX)")
            _gLayer.frame = CGRect(x:pointX, y: self.contentOffset.y, width: self.bounds.size.width*5, height: self.bounds.size.height)
            _gLayer.removeAllAnimations()

        }
        
        


    }
    
}




extension SDGradientView {

    
    func startMoving() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(SDGradientView.updateFrames))
            displayLink!.add(to: .main, forMode: .common)
        }

    }
    
    @objc func updateFrames()  {
        contentOffset.x += 1
        layoutGradientLayer()
    }
}
