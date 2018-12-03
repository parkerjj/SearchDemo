//
//  DetailViewController.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/2/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation
import SafariServices

class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView        : UIImageView?
    @IBOutlet private weak var authorNameLabel  : UILabel?
    @IBOutlet private weak var authorAvatarView : UIImageView?

    var photoInfo : PhotoInfo? {
        didSet {
            reloadDetail()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildRootView()
        reloadDetail()
    }
    
    private func buildRootView() {
        authorAvatarView?.layer.cornerRadius = (authorAvatarView?.bounds.size.height)!/2.0
        authorAvatarView?.layer.borderColor = UIColor(hex: 0x777777, alpha: 0.8)?.cgColor
        authorAvatarView?.layer.borderWidth = 2.0
        authorAvatarView?.clipsToBounds = true
        
        
        let animationController = RZRectZoomAnimationController()
        animationController.rectZoomDelegate = self
        RZTransitionsManager.shared().setAnimationController(animationController, fromViewController: DetailViewController.self, toViewController: FallViewController.self, for: .pop)
        
        
        
        // Setup Back Button\
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "BackButton");
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.setTitle("Back", for: .normal);
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (goBack), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        

    }
    
    
    private func reloadDetail() {
        
        // Load Medium first, Then download Large file
        imageView?.sd_setImage(with: URL(string: (photoInfo?.photoURL.medium)!), completed: { (image, error, type, url) in
            self.imageView?.sd_setImage(with: URL(string: ((self.photoInfo?.photoURL.large)!)), placeholderImage: image, options: .retryFailed, completed: nil)
        })
        
        authorNameLabel?.text = photoInfo?.photographer
        //This API doesn't support Author Avatar right now
//        authorAvatarView?.sd_setImage(with: T##URL?, completed: T##SDExternalCompletionBlock?##SDExternalCompletionBlock?##(UIImage?, Error?, SDImageCacheType, URL?) -> Void)
        
        
    }
    
    @IBAction private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func goButtonClicked() {
        let sfVC = SFSafariViewController(url: URL(string: (photoInfo?.url)!)!)
        self.navigationController?.pushViewController(sfVC, animated: true)
        
    }
    
}


extension DetailViewController : RZRectZoomAnimationDelegate {
    func rectZoomPosition() -> CGRect {
        return (imageView?.frame)!;
    }
}
