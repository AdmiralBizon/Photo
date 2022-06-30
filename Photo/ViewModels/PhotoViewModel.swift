//
//  PhotoViewModel.swift
//  Photo
//
//  Created by Ilya on 30.06.2022.
//

import Foundation

final class PhotoViewModel {
    
    @Published var data: Photo?
    
    func fetchPhotoDetails(photoId: String) {
        guard !photoId.isEmpty else { return }
        
        NetworkService.shared.fetchImageDetails(photoId: photoId) { [weak self] response in
            switch response {
            case .success(let receivedData):
                self?.data = receivedData
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
