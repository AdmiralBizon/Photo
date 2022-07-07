//
//  Constants.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

struct K {
    static let scheme = "https"
    static let host = "api.unsplash.com"
    static let randomPhotosPath = "/photos/random/"
    static let searchPhotosPath = "/search/photos"
    static let photoDetailsPath = "/photos/"
    static let photosOnPage = 30
    static let detailsViewControllerIndentifier = "PhotoDetailsViewController"
    static let detailCellIdentifier = "DetailCell"
    static let userDefaultsKey = "FavoritePhotos"
}
