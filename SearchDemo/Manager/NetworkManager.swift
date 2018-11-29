//
//  NetworkManager.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation


enum Result<T> {
    case Success(T: MotherResult)
    case Error()
}


class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {    }
    
    
    
}


extension NetworkManager  {
    
    
    func get<T : MotherResult>(api : String , params : [String : String], resultType : T.Type, completion : (T) -> ()) {
        
        let retValue = T.self()
        completion(retValue)
    }
    
}
