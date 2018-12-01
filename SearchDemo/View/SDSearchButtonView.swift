//
//  SDSearchButton.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/30/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation
import UIKit

 protocol SDSearchButtonViewActionProtocol : class , UITextFieldDelegate {
    func searchButtonClicked( button : SDSearchButtonView ) -> Void
    func phaseOneCompleted(button : SDSearchButtonView)
}


enum SDSearchButtonTransform {
    case circle
    case expend
}

class SDSearchButtonView : UIView {

    private let _textField          = UITextField(frame: CGRect())
    private let _magnGlassButton    = UIButton(type: UIButton.ButtonType.custom)
    @IBOutlet var _widthConstraint  : NSLayoutConstraint?
    @IBOutlet var _bottomConstraint : NSLayoutConstraint?
    
    var transformStatus = SDSearchButtonTransform.circle {
        willSet {
            animationTransform(newTransform: newValue)
        }
    }
    weak var delegate : SDSearchButtonViewActionProtocol?{
        didSet{
            _textField.delegate = delegate
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildRootView()
    }
    
    
    private func buildRootView(){
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = self.frame.size.width/2.0
        
        
        let margin : CGFloat = 10.0
        // Setup Button
        _magnGlassButton.frame = CGRect(x: margin, y: margin, width: self.frame.size.width - 2*margin, height: self.frame.size.height - 2*margin)
        _magnGlassButton.setImage(UIImage(named: "MagnifyingGlass"), for: .normal)
        _magnGlassButton.addTarget(self, action: #selector(SDSearchButtonView.searchButtonClicked(sender:)), for: .touchUpInside)
        self.addSubview(_magnGlassButton)
        
        // Setup TextField
        _textField.backgroundColor = UIColor.red
        self.addSubview(_textField)
    }
    
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        
        if _textField.constraints.count == 0 {
            // Add TextField Layout
            _textField.snp.makeConstraints { (maker) in
                maker.left.equalTo(_magnGlassButton.snp.right).inset(0)
                maker.right.equalTo(self).inset(15)
                maker.height.equalTo(_magnGlassButton)
                maker.top.equalTo(_magnGlassButton.snp.top)
            }
        
        }
    }
    
    private func animationTransform( newTransform : SDSearchButtonTransform){
        
        guard transformStatus != newTransform else {
            return
        }
        
        
        // Phase 1 Animation Start
        let expendWidthValue : CGFloat = 240.0
        switch newTransform {
        case .circle:
            _widthConstraint?.constant -= expendWidthValue
            break
        case .expend:
            _widthConstraint?.constant += expendWidthValue
            break
        }
        
        let expendBottomValue : CGFloat = UIScreen.main.bounds.size.height * 0.6
        UIView.animate(withDuration: 0.5, animations: {
            self.superview?.layoutIfNeeded()
        }) { (finished) in
            // Phase 1 Animation End
            self.delegate?.phaseOneCompleted(button: self)
            
            // Phase 2 Animation Start
            switch newTransform {
            case .circle:
                self._bottomConstraint?.constant -= expendBottomValue
                break
            case .expend:
                self._bottomConstraint?.constant += expendBottomValue
                break
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { (finish) in
                
                if self.transformStatus == .expend {
                    self._textField.becomeFirstResponder()
                }
            })
            
            // Phase 2 Animation Done
            
        }
        
    }
    
    
}


extension SDSearchButtonView {
    @objc func searchButtonClicked( sender : Any) {
        delegate?.searchButtonClicked(button: self)
    }
}

