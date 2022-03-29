//
//  MovieAppTeest.swift
//  MovieAppTests
//
//  Created by Admin on 24/03/2022.
//

import XCTest
import Combine
@testable import MovieApp

class MovieAppTest: XCTestCase {
    private var subscribers = Set<AnyCancellable>()

    var viewModel: SearchViewModel!

    let fakeNetworkManager = MockNetworkManager()
    
    override func setUpWithError() throws {
       
        
        fakeNetworkManager.baseUrl = "Movie_response"

        viewModel = SearchViewModel(networkManager: fakeNetworkManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchMovies_success() {
        
        let expectation = expectation(description: "waiting for call")
        
        viewModel
            .$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 20)
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.searchMovies(searchedText: "Movie_response")
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchMovies_failure() {
        
        let expectation = expectation(description: "waiting for call")
        fakeNetworkManager.baseUrl = "failure_responce"
        
        viewModel
            .$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 0)
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.searchMovies(searchedText: "failure_responce")
        
        waitForExpectations(timeout: 1.0)
    }
}
