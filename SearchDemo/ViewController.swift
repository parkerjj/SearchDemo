//
//  ViewController.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import UIKit
import SceneKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet var searchButton : SDSearchButtonView!
    @IBOutlet var historyView : SKView!
    @IBOutlet var bannerView1 : SDScrolledCollectionView!
    @IBOutlet var bannerView2 : SDScrolledCollectionView!
    private var _animatedMenuScene = AnimatedMenuScene(size: CGSize())
    private var _dataArray = [CuratedPhotoResult]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NetworkManager.shared.get(api: "search", params: ["query":"people"], resultType: SearchPhotoResult.self) { (returnCode, result) in
            print("Type is \(String(describing: result))")
        }



        buildRootView()
        initBannerData()
        
    }
    
    func buildRootView() {
        
        
        searchButton.delegate = self
        
        historyView.isHidden = true
        historyView.alpha = 0.0
        historyView.backgroundColor = .clear
        historyView.layer.cornerRadius = 15.0
        historyView.clipsToBounds = false
        
        _animatedMenuScene.animatedSceneDelegate = self
        _animatedMenuScene.backgroundColor = .clear

        
        historyView.presentScene(_animatedMenuScene)
        
        // Rotate CollectionView
        var angel =  CGFloat(arc4random() % 100) / 100.0 / 4.0 * CGFloat(Double.pi)
        bannerView1.transform = CGAffineTransform(rotationAngle:angel)
        bannerView1.direction = .right
        
        angel =  CGFloat(arc4random() % 100) / 100.0 / 4.0 * CGFloat(Double.pi) * -1
        bannerView2.transform = CGAffineTransform(rotationAngle:angel)
        bannerView2.direction = .right


    }
    
    


}

// MARK: - Load Init Data & Banner Controll
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func initBannerData() {
        
        for _ in 0..<2 {
            let randomPage = Int(arc4random() % UInt32(100))
            NetworkManager.shared.get(api: "curated", params: ["per_page": 50, "page" : randomPage], resultType: CuratedPhotoResult.self) { (returnCode, result) in
                
                if returnCode >= 0 {
                    self._dataArray.append(result!)
                    self.bannerView1.reloadData()
                    self.bannerView1.startMoving()
                    
                    self.bannerView2.reloadData()
                    self.bannerView2.startMoving()

                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (_dataArray.count > 0) else {
            return 0
        }
        
        let result = (collectionView == bannerView1) ? self._dataArray.first : self._dataArray.last

        return  (result!.photos?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCollectionViewReuseId", for: indexPath) as! BaseCollectionViewCell
        
        
        let result = (collectionView == bannerView1) ? self._dataArray.first : self._dataArray.last
        let urlString = result?.photos![indexPath.row].photoURL.medium
        
        cell.imageView.sd_setImage(with: URL(string: urlString!), completed: nil)
        cell.layoutIfNeeded()
        return cell
    }
}


// MARK: - SDSearchButtonViewActionProtocol & Animation
extension ViewController : SDSearchButtonViewActionProtocol {
    func searchButtonClicked(button: SDSearchButtonView) {
        button.transformStatus = .expend
    }
    
    func phaseOneCompleted(button: SDSearchButtonView) {
        
        if button.transformStatus == .expend {
            bannerViewMoveOut()
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
            historyView.presentScene(_animatedMenuScene)
            self.refreshAndLayoutHistory()

        }else if button.transformStatus == .circle {
            bannerViewMoveIn()
            
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
    
    func bannerViewMoveOut() {
        bannerView1.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).inset(-UIScreen.main.bounds.size.height)
        }
        
        bannerView2.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).inset(-UIScreen.main.bounds.size.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func bannerViewMoveIn() {
        var angel =  CGFloat(arc4random() % 100) / 100.0 / 4.0 * CGFloat(Double.pi)
        bannerView1.transform = CGAffineTransform(rotationAngle:angel)
        
        angel =  CGFloat(arc4random() % 100) / 100.0 / 4.0 * CGFloat(Double.pi) * -1
        bannerView2.transform = CGAffineTransform(rotationAngle:angel)

        
        bannerView1.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).inset(60)
        }
        
        bannerView2.snp.remakeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).inset(130)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        historyView.isHidden = true
        self._animatedMenuScene.removeAllChildren()
        
        searchButton.transformStatus = .circle
        searchButton.startLoading()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: - History
extension ViewController  : AnimatedMenuSceneDelegate{
    func refreshAndLayoutHistory() {
        self._animatedMenuScene.size = self.historyView.frame.size
        for _ in 0...5 {
            let node = MenuItemNode.menuNode(withTitle: "Test", withPercentageSize: 0.5)
            self._animatedMenuScene.addChild(node!)
        }
    }
}

// MARK: Busniess Logic
extension ViewController{
    func searchQuary( keyWord : String ) {
        
    }
}
