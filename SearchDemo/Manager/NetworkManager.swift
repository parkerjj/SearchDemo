//
//  NetworkManager.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation



class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {    }
    
    
    
}


extension NetworkManager  {
    
    
    func get<T : MotherResult>(api : String , params : [String : String], resultType : T.Type, completion : (T) -> ()) {
        
        
        
//        let jsonDecoder = JSONDecoder()
//        let modelObject = try? jsonDecoder.decode(T.self, from: data!)
//        guard (modelObject != nil) else {
//            return
//        }
//
//        completion(modelObject!)
        

        

    }
    
}
