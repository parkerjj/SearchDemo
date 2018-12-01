//
//  ViewController.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bannerView : SDGradientView!
    @IBOutlet var searchButton : SDSearchButtonView!
    @IBOutlet var historyView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        NetworkManager.shared.get(api: "search", params: ["query":"people"], resultType: SearchPhotoResult.self) { (returnCode, result) in
//            print("Type is \(String(describing: result))")
//        }
        
        buildRootView()
        
    }
    
    func buildRootView() {
        
        bannerView.contentSize = CGSize(width: Double(MAXFLOAT), height: 0.0)
        bannerView.gradientColors = [UIColor.red.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor]
        bannerView.startMoving()
        
        
        searchButton.delegate = self
        
        historyView.isHidden = true
        historyView.alpha = 0.0
        historyView.layer.cornerRadius = 15.0
        historyView.clipsToBounds = true
        
    }
    
    


}

extension ViewController : SDSearchButtonViewActionProtocol {
    func searchButtonClicked(button: SDSearchButtonView) {
        
        button.transformStatus = .expend
    }
    
    func phaseOneCompleted(button: SDSearchButtonView) {
        
        if button.transformStatus == .expend {
            historyView.isHidden = false
            
            let heightValue : CGFloat = UIScreen.main.bounds.size.height * 0.3
            historyView.snp.updateConstraints { (maker) in
                maker.height.equalTo(heightValue)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.historyView.alpha = 1.0
                self.view.layoutIfNeeded()
            }) { (finished) in
                
            }
        }else if button.transformStatus == .circle {
            historyView.snp.updateConstraints { (maker) in
                maker.height.equalTo(0)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.historyView.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.historyView.isHidden = true

            }
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchButton.transformStatus = .circle
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

