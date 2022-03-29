//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation


protocol NetworkType {
    var baseUrl:String {get}
    func get<T: Codable>(_ path:String, params:[String: String], model: T.Type,  completion: @escaping (Result<T, NetworkError>) -> Void)
}
class NetworkManager: NetworkType {
    var baseUrl: String
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func get<T>(_ path: String, params: [String : String], model: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable, T : Encodable {
        
        var urlComponents = URLComponents(string: baseUrl + path)
        
        let queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(model, from: data)
                    completion(.success(response))
                } catch let error  {
                    completion(.failure(.other(error)))
                }
            }
        }
        .resume()
        
    }
}
