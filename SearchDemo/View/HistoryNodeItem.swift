//
//  HistoryNodeItem.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation
import SpriteKit

class HistoryNodeItem: SKShapeNode {
    var title : String
    
    override init() {
        self.title = ""

        super.init()
        
        self.path = CGPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerWidth: 50, cornerHeight: 50, transform: nil)
        self.strokeColor = UIColor.red
        self.fillColor = UIColor.red
    }
    
    convenience init(_titie : String) {
        self.init()
        self.title = _titie

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


