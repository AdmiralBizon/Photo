//
//  NetworkService.swift
//  Photo
//
//  Created by Ilya on 29.06.2022.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchData<T:Codable>(path: String, query: String? = nil, type: T.Type, completionHandler: @escaping (Result<T,Error>) -> Void) {

        guard let token = Bundle.main.infoDictionary?["API_KEY"] as? String else { return }
        
        let url = prepareURL(path: path, parameters: prepareParameters(query: query))
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data!)
                completionHandler(.success(decodedData))
            } catch let error {
                completionHandler(.failure(error))
            }

        }.resume()
    }
    
    private func prepareParameters(query: String? = nil) -> [String: String] {
        var parameters = [String: String]()
        
        if let query = query {
            parameters["query"] = query
        }
        
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

