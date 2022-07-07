//
//  SearchResponse.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

struct SearchResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
}
