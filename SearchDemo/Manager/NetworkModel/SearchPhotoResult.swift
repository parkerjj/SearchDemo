//
//  SearchPhotoResult.swift
//  SearchDemo
//
//  Created by Peigen.Liu on 11/29/18.
//  Copyright © 2018 Peigen.Liu. All rights reserved.
//

import Foundation


struct SearchPhotoResult : MotherResult  {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: SearchPhotoResultCodingKeys.self)
        
        totalResult = try values.decode(Int.self, forKey: .totalResult)
        page        = try values.decode(Int.self, forKey: .page)
        perPage     = try values.decode(Int.self, forKey: .perPage)
        photos      = try values.decode([PhotoInfo].self, forKey: .photos)

    }
    
    func encode(to encoder: Encoder) throws {
        var container   = encoder.container(keyedBy: SearchPhotoResultCodingKeys.self)
        try container.encode(totalResult, forKey: .totalResult)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
        try container.encode(photos, forKey: .photos)
    }
    
    

    

    var totalResult     : Int
    var page            : Int
    var perPage         : Int
    var photos          : [PhotoInfo]?
    

    enum SearchPhotoResultCodingKeys: String, CodingKey {
        case totalResult = "total_results"
        case page
        case perPage     = "per_page"
        case photos
    }
    
    
}
