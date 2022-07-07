//
//  PhotoViewModel.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

final class PhotoViewModel {
    
    @Published var currentPhoto: Photo?
    @Published var allPhotos = [Photo]()
    @Published var favorites = [Photo]() {
        didSet {
            saveFavorites()
        }
    }

    init() {
        loadFavorites()
    }
    
    // MARK: - Fetching data
    
    func fetchRandomPhotos() {
        NetworkService.shared.fetchData(path: K.randomPhotosPath,
                                        type: [Photo].self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.allPhotos = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSearchResults(query: String) {
        NetworkService.shared.fetchData(path: K.searchPhotosPath, query: query, type: SearchResponse.self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.allPhotos = data.results
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPhotoDetails(photoId: String) {
        guard !photoId.isEmpty else { return }
        
        let path = K.photoDetailsPath + photoId
        guard !path.isEmpty else { return }
        
        NetworkService.shared.fetchData(path: path, type: Photo.self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.currentPhoto = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Favorites

    func loadFavorites() {
        if let savedObject = UserDefaults.standard.object(forKey: K.userDefaultsKey) as? Data {
            let decoder = JSONDecoder()
            if let savedFavorites = try? decoder.decode([Photo].self, from: savedObject) {
                favorites = savedFavorites
            }
        }
    }

    func saveFavorites() {
        let encoder = JSONEncoder()
        if let encodedObject = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encodedObject, forKey: K.userDefaultsKey)
        }
    }

    func addToFavorites(photo: Photo) {
        if !favorites.contains(photo) {
            favorites.append(photo)
        }
    }

    func removeFromFavorites(photo: Photo) {
        if let index = favorites.firstIndex(of: photo) {
            favorites.remove(at: index)
        }
    }

    func isFavorite(photoId: String) -> Bool {
        guard !photoId.isEmpty else { return false }
        return (favorites.filter{ $0.id == photoId }.first) != nil
    }

}
