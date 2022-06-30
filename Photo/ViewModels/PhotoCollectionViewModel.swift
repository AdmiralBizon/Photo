//
//  PhotoCollectionViewModel.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

final class PhotoCollectionViewModel {
    
    @Published var data = [Photo]()
 
    func fetchPhotoList(query: String? = nil) {
        
        if query != nil {
            
            NetworkService.shared.fetchImages(query: query!) { [weak self] response in
                switch response {
                case .success(let data):
                    self?.data = data.results
                case .failure(let error):
                    print(error)
                }
            }
            
        } else {
        
            NetworkService.shared.fetchImages { [weak self] response in
                switch response {
                case .success(let receivedData):
                    self?.data = receivedData
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
}
