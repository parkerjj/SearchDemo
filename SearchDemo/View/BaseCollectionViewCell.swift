//
//  MainViewCollectionViewCell.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation


class BaseCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView(frame: CGRect())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        
    }
}
