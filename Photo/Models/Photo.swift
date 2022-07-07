//
//  Photo.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

struct Photo: Codable {
    let id: String
    let createdDate: String
    let downloads: Int?
    let location: Location?
    let urls: [String : String]
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdDate = "created_at"
        case downloads
        case location
        case urls
        case user
    }
    
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}
