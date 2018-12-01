//
//  PhotoInfo.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation



struct PhotoInfo : Codable {
    let id              : Int
    let width           : Int
    let height          : Int
    let url             : String
    let photographer    : String
    let photographerURL : String
    let photoURL        : PhotoURL
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PhotoResultCodingKeys.self)
        
        id                  = try values.decode(Int.self, forKey: .id)
        width               = try values.decode(Int.self, forKey: .width)
        height              = try values.decode(Int.self, forKey: .height)
        url                 = try values.decode(String.self, forKey: .url)
        photographer        = try values.decode(String.self, forKey: .photographer)
        photographerURL     = try values.decode(String.self, forKey: .photographerURL)
        photoURL            = try values.decode(PhotoURL.self, forKey: .photoURL)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container   = encoder.container(keyedBy: PhotoResultCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(url, forKey: .url)
        try container.encode(photographer, forKey: .photographer)
        try container.encode(photographerURL, forKey: .photographerURL)
        try container.encode(photoURL, forKey: .photoURL)
    }
    
    enum PhotoResultCodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case photographer
        case photographerURL    = "photographer_url"
        case photoURL           = "src"
    }
    
    
    struct PhotoURL : Codable {
        let original     : String
        let large        : String
        let medium       : String
        let small        : String
        
        
    }
    
    
    
    
}
