//
//  MovieDataModel.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation

class SearchViewModel {
    
    private let networkManager: NetworkType
    
    var movieRecords = [MovieRecord]()

    @Published private(set) var movies = [Movie]()
    
    init(networkManager: NetworkType = NetworkManager(baseUrl: Utils.baseUrl)) {
        self.networkManager = networkManager
    }
    
    func searchMovies(searchedText: String) {
        if searchedText.count >= 3 {
           
            networkManager.get(Utils.searchPath, params: ["api_key": Utils.apiKey, "language":"en-US", "query":searchedText], model: MoviesResponse.self) { [weak self] result in
    
                    switch result {
                    case .success(let response):
                        let results = response.results
                        self?.movieRecords =  results.map {
                            MovieRecord(name: $0.title ?? "", url:$0.backdropPath ?? "", overView: $0.overview ?? "")
                        }
                        self?.movies = results
                        
                    case .failure(_):
                        self?.movieRecords = []
                        self?.movies = []
                    }
                }
        }
    }
}
