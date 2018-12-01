//
//  CuratedPhotoResult.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 12/1/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation



struct CuratedPhotoResult : MotherResult  {
    var page            : Int
    var perPage         : Int
    var photos          : [PhotoInfo]?
    var nextPage        : String
    
    
    init() {
        page = 0
        perPage = 0
        photos = [PhotoInfo]()
        nextPage = ""
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CuratedPhotoResultCodingKeys.self)
        
        page        = try values.decode(Int.self, forKey: .page)
        perPage     = try values.decode(Int.self, forKey: .perPage)
        photos      = try values.decode([PhotoInfo].self, forKey: .photos)
        nextPage    = try values.decode(String.self, forKey: .nextPage)

        
    }
    
    func encode(to encoder: Encoder) throws {
        var container   = encoder.container(keyedBy: CuratedPhotoResultCodingKeys.self)
        try container.encode(nextPage, forKey: .nextPage)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
        try container.encode(photos, forKey: .photos)
    }
    
    
    
    
    


    
    enum CuratedPhotoResultCodingKeys: String, CodingKey {
        case nextPage    = "next_page"
        case page
        case perPage     = "per_page"
        case photos
    }
    
    
    
    
    
}
