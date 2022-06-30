//
//  SearchResponse.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

struct SearchResponse: Decodable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}
