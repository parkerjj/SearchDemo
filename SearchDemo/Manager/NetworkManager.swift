//
//  NetworkManager.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation



let kHostURL = "http://api.pexels.com/v1/"
let kAPIKey = "563492ad6f91700001000001418e83d2a1f84cc0a33cc1ec39b3ef57"



class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {    }
    
    
    
}


extension NetworkManager  {
    
    
    
    /// Get Method of Network Request
    ///
    /// - Parameters:
    ///   - api: API
    ///   - params: Params
    ///   - resultType: The Result Class/Type you expected
    ///   - completion: Completion closure
    func get<T : MotherResult>(api : String , params : [String : Any], resultType : T.Type, completion : @escaping (Int, T?) -> ()) {
        
        // Combine Parameters into Component
        var components = URLComponents(string: kHostURL + api)
        if !params.isEmpty {
            components?.queryItems = [URLQueryItem]()
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components?.queryItems!.append(queryItem)
            }
        }
        
        
        
        // Create URL Session
        let session = URLSession.shared;
        var dataTask: URLSessionDataTask?

        guard let url = components?.url else { return }
        
        // Setup Request and Its Header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(kAPIKey, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10.0
        
        // Begin a data task
        dataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(-1 , nil)
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                let jsonDecoder = JSONDecoder()
                let modelObject = try? jsonDecoder.decode(T.self, from: data)
                guard (modelObject != nil) else {
                    DispatchQueue.main.async {
                        completion(-1 , nil)
                    }
                    return
                }
                

                
                DispatchQueue.main.async {
                    completion(0 ,modelObject!)
                }
            }
        }
        // 7
        dataTask?.resume()
        
        

        

    }
    
}
