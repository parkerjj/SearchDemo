//
//  WaterFallCollectionViewCell.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/2/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation


class WaterFallCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImageView        : UIImageView!
    @IBOutlet var authorNameLabel       : UILabel!


    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.backgroundColor = UIColor.white
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 8.0
    }
    
    
    func setText(text : String){
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 5.0;
        shadow.shadowOffset = CGSize()
        shadow.shadowColor = UIColor.black
        
        let aStr = NSMutableAttributedString(string: text)
        aStr.addAttributes([NSAttributedString.Key.shadow : shadow], range: NSRange(location: 0, length: aStr.length - 1))
        authorNameLabel.attributedText = aStr
        
    }
    
}
