//
//  ViewController.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NetworkManager.shared.get(api: "search", params: ["query":"people"], resultType: SearchPhotoResult.self) { (returnCode, result) in
            print("Type is \(String(describing: result))")
        }
        
    }


}

