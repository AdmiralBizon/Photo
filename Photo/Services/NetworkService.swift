//
//  NetworkService.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init(){}
    
    func fetchImages(completionHandler: @escaping (Result<[Photo], Error>) -> Void) {
        
        let url = prepareURL(path: K.randomPhotosPath, parameters: prepareParameters())
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(K.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Invalid data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Photo].self, from: data)
                return completionHandler(.success(decodedData))
            } catch let error {
                completionHandler(.failure(error))
            }
            
        }.resume()
    }
    
    func fetchImages(query: String, completionHandler: @escaping (Result<SearchResponse, Error>) -> Void) {
        
        let url = prepareURL(path: K.searchPhotosPath, parameters: prepareParameters(query: query))
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(K.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Invalid data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(SearchResponse.self, from: data)
                return completionHandler(.success(decodedData))
            } catch let error {
                completionHandler(.failure(error))
            }
            
        }.resume()
    }
    
    func fetchImageDetails(photoId: String, completionHandler: @escaping (Result<Photo, Error>) -> Void) {
        
        let path = K.photoDetailsPath + photoId
        let url = prepareURL(path: path, parameters: nil)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(K.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Invalid data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Photo.self, from: data)
                return completionHandler(.success(decodedData))
            } catch let error {
                completionHandler(.failure(error))
            }
            
        }.resume()
    }
    
//    func fetchData<T:Decodable>(path: String, query: String = "", expecting: T.Type? = nil, completionHandler: @escaping (Result<T,Error>) -> Void) {
//
//        if let expecting = expecting {
//            modelType = expecting
//        }
//
//        let parameters = !query.isEmpty ? prepareParameters(query: query) : nil
//        let url = prepareURL(path: path, parameters: parameters)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Client-ID \(K.token)", forHTTPHeaderField: "Authorization")
//
//        //let defaultType = [Photo].self
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//
//            if let error = error {
//                completionHandler(.failure(error))
//                return
//            }
//
//
//
//            let type = expecting != nil ? expecting : [Photo].self
//
//            //completionHandler( Result{ try JSONDecoder().decode(T.self, from: data!) })
//
//            do {
//                let decodedData = try JSONDecoder().decode(expecting, from: data!)
//                return completionHandler(.success(decodedData))
//            } catch let error {
//                completionHandler(.failure(error))
//            }
//
//        }.resume()
//    }
    
    private func prepareParameters(query: String = "") -> [String: String] {
        var parameters = [String: String]()
        
        if !query.isEmpty {
            parameters["query"] = query
        }
        
        //parameters["page"] = String(1)
        parameters["count"] = String(K.photosOnPage)
        return parameters
    }
    
    private func prepareURL(path: String, parameters: [String: String]?) -> URL {
        var components = URLComponents()
        components.scheme = K.scheme
        components.host = K.host
        components.path = path
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        }
        return components.url!
    }
    
}

