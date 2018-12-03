//
//  File.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation


class FallViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            // Setup Waterfall Layout
            let layout = CHTCollectionViewWaterfallLayout()
            layout.columnCount = 2
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            layout.minimumInteritemSpacing = 8.0
            collectionView.collectionViewLayout = layout
            collectionView.dataSource = self
            collectionView.delegate = self
            
            
            // Setup Pull up Refresh
            collectionView.gtm_addLoadMoreFooterView {
                [weak self] in
                self!.loadMore()
            }.refreshFailureText("No more content")
        }
    }
    
    var dataResult : SearchPhotoResult? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var keyWord : String? = "" {
        didSet {
            self.title = keyWord
        }
    }
    
    private var animationControllerToDetail = RZCardSlideAnimationController()
    private var animationStartRect = CGRect()
    
    @IBOutlet private var bgImageView   : UIImageView?
    @IBOutlet private var headerView    : UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Transition
        self.transitioningDelegate = RZTransitionsManager.shared()
        self.navigationController!.delegate = RZTransitionsManager.shared()
        
        // Set Navigation Style
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Setup Header View
        let gLayer = CAGradientLayer()
        gLayer.frame = CGRect(x: 0, y: 0, width: 1000, height: (headerView?.frame.size.height)!)
        gLayer.colors = [UIColor(white: 1.0, alpha: 1.0).cgColor,
                         UIColor(white: 1.0, alpha: 0.7).cgColor,
                         UIColor(white: 1.0, alpha: 0.0).cgColor]
        gLayer.locations = [NSNumber(value: 0.4),NSNumber(value: 0.8),NSNumber(value: 1.0)]
        gLayer.startPoint = CGPoint(x: 0, y: 0)
        gLayer.endPoint = CGPoint(x: 0, y: 1)
        headerView?.layer.addSublayer(gLayer)

        // Set Blur
        self.bgImageView?.image = UIImage(named: "Background")?.blurredImage(withRadius: 10, iterations: 3, tintColor: UIColor.black)

    }
    
    
    
    @IBAction func backButtonClicked(sender : UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    
    
    private func loadMore() {
        
        NetworkManager.shared.get(api: "search", params: ["query":keyWord! , "per_page":40, "page" : (dataResult?.page)!+1], resultType: SearchPhotoResult.self) { (returnCode, result) in
            self.collectionView.refreshControl?.endRefreshing()
            if returnCode >= 0 {
                self.dataResult?.page = (result?.page)!
                self.dataResult?.photos? += (result?.photos)!
                self.collectionView.gtmFooter?.endLoadMore(isNoMoreData: result?.totalResult == 0)

                
                self.collectionView.reloadData()
            }else{
                self.collectionView.gtmFooter?.endLoadMore(isNoMoreData: true)
            }
        }
    }
}



// MARK: - Segue Acion
extension FallViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = RZTransitionsManager.shared()
        
        if segue.identifier == "Fall2Detail" {
            let controller = controller as! DetailViewController
            controller.photoInfo = (sender as! PhotoInfo)
            
            RZTransitionsManager.shared().setAnimationController(animationControllerToDetail, fromViewController: FallViewController.self, toViewController: DetailViewController.self, for: .pushPop)
            
        }
    }
}


extension FallViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterFallCollectionViewCell", for: indexPath) as! WaterFallCollectionViewCell
        
        
        let photoInfo = dataResult?.photos![indexPath.row]
        
        cell.photoImageView.sd_setImage(with: URL(string: (photoInfo?.photoURL.medium)!), completed: nil)
        cell.setText(text: photoInfo?.photographer ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (self.dataResult != nil) else {
            return 0
        }
        
        return (dataResult?.photos?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animationStartRect = collectionView.convert((collectionView.cellForItem(at: indexPath)?.frame)!, to: self.view)
        let photoInfo = dataResult?.photos![indexPath.row]
        self.performSegue(withIdentifier: "Fall2Detail", sender: photoInfo)
    }
    
}

extension FallViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let photoInfo = dataResult?.photos![indexPath.row]
        return CGSize(width: (photoInfo?.height)!, height: (photoInfo?.width)!)
    }
}



extension FallViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let alpha : CGFloat = scrollView.contentOffset.y / 70.0
        headerView?.alpha = alpha
    }
}
