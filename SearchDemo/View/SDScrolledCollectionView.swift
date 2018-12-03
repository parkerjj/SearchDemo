//
//  SDScrolledCollectionView.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation


enum SDScrolledCollectionViewMoveDirection {
    case left
    case right
}


class SDScrolledCollectionView: UICollectionView {
    var displayLink : CADisplayLink?
    var direction = SDScrolledCollectionViewMoveDirection.left
    var speed : CGFloat = 0.5

}



// MARK: - Auto Scroll
extension SDScrolledCollectionView {
    func startMoving() {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(SDGradientView.updateFrames))
            displayLink!.add(to: .main, forMode: .common)
        }
        
    }
    
    @objc func updateFrames()  {
        if direction == .left {
            contentOffset.x -= speed

            
            if (contentOffset.x < self.bounds.size.width/2) {
                // Out of bound
                self.setContentOffset(CGPoint(x: contentSize.width, y: 0), animated: false)

                return
            }
        }else {
            contentOffset.x += speed
            if (contentOffset.x > (contentSize.width - self.bounds.size.width)) {
                // Out of bound
                self.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                return
            }
        }
    }
}
