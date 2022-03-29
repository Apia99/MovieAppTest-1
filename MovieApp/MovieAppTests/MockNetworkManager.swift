//
//  MockNetworkManager.swift
//  MovieAppTests
//
//  Created by Admin on 25/03/2022.
//

import Foundation
@testable import MovieApp

class MockNetworkManager: NetworkType {
    var baseUrl: String = ""
    
    func get<T>(_ path: String, params: [String : String], model: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable, T : Encodable {
            
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:baseUrl, withExtension:"json"),
                  let data = try? Data(contentsOf: url)
        else {
            completion(.failure(.badURL))
            return
            }
            
            do {
                let response = try JSONDecoder().decode(model, from: data)
                
                completion(.success(response))
                
            } catch let error  {
                completion(.failure(.other(error)))
            }
            
        }
    }
    
    

