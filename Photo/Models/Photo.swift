//
//  Photo.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let created_at: String
    let downloads: Int?
    let location: Location?
    let urls: [String : String]
    let user: User
}

