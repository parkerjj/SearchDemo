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

class MainViewController: UIViewController {
    @IBOutlet var searchButton : SDSearchButtonView!
    @IBOutlet var historyView : SKView!
    @IBOutlet var bannerView1 : SDScrolledCollectionView!
    @IBOutlet var bannerView2 : SDScrolledCollectionView!
    private var _animatedMenuScene = AnimatedMenuScene(size: CGSize())
    private var _dataArray = [CuratedPhotoResult]()
    
    // For Transition
    private let transition = BubbleTransition()
    private let interactiveTransition = BubbleInteractiveTransition()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource {
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
            return 4
        }
        
        let result = (collectionView == bannerView1) ? self._dataArray.first : self._dataArray.last

        return  (result!.photos?.count)! + 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCollectionViewReuseId", for: indexPath) as! BaseCollectionViewCell
        
        if indexPath.row < 4 {
            let offset = collectionView == bannerView1 ?  0 : 4
            cell.imageView.image = UIImage(named: "Default_" + String(offset + indexPath.row))
            return cell
        }
        
        
        let result = (collectionView == bannerView1) ? self._dataArray.first : self._dataArray.last
        let urlString = result?.photos![indexPath.row - 4].photoURL.medium
        
        cell.imageView.sd_setImage(with: URL(string: urlString!), completed: nil)
        cell.layoutIfNeeded()
        return cell
    }
}


// MARK: - SDSearchButtonViewActionProtocol & Animation
extension MainViewController : SDSearchButtonViewActionProtocol {
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
        
        guard (textField.text != nil && (textField.text?.count)! > 0) else {
            return
        }
        searchQuary(keyWord: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: - History
extension MainViewController  : AnimatedMenuSceneDelegate{
    
    func historyArray () ->  [String]{
        var historyArray : [String]? = StorageManager.getLocalValue(forKey: "HistoryArray") as? [String]
        if historyArray == nil {
            historyArray = ["Light","City","Food","Cat","Plant"]
        }
        
        return historyArray!
    }
    
    func refreshAndLayoutHistory() {
        self._animatedMenuScene.size = self.historyView.frame.size
        
        
        
        for str in historyArray() {
            let percent = 0.4 + Double(arc4random()%3) / 10.0
            let node = MenuItemNode.menuNode(withTitle: str, withPercentageSize: CGFloat(percent))
            self._animatedMenuScene.addChild(node!)
        }
    }
    
    
    func animatedMenuScene(_ animatedScene: AnimatedMenuScene!, didSelectNodeAt index: Int) {
        searchButton.clearTextField()
        searchButton.transformStatus = .circle
        
        let str = historyArray()[index]
        searchQuary(keyWord: str)
    }
}

// MARK: Busniess Logic
extension MainViewController{
    func searchQuary( keyWord : String ) {
        searchButton.clearTextField()

        searchButton.startLoading()
        
        
        NetworkManager.shared.get(api: "search", params: ["query":keyWord], resultType: SearchPhotoResult.self) { (returnCode, result) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.searchButton.stopLoading()
            })
            
            if returnCode >= 0 {
                var historyArray = self.historyArray()
                historyArray.insert(keyWord, at: 0)
                
                // Remove Duplicate
                var result = [String]()
                for value in historyArray {
                    if result.contains(value) == false {
                        result.append(value)
                    }
                }
                historyArray = Array(result[0..<5])
                
                // Storage History Array
                StorageManager.setLocalValueWithValue(historyArray as NSCopying, forKey: "HistoryArray")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.performSegue(withIdentifier: "Main2Fall", sender: result)
                })
                
            }
        }
        
        
    }
}


extension MainViewController : UIViewControllerTransitioningDelegate {
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = searchButton.center
        transition.bubbleColor = searchButton.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = searchButton.center
        transition.bubbleColor = searchButton.backgroundColor!
        return transition
    }
    
}
