//
//  ImageDownloader.swift
//  MovieApp
//
//  Created by Admin on 29/03/22.
//

import Foundation
import UIKit

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader: Operation {
    let movieRecord: MovieRecord
    init(_ movieRecord: MovieRecord) {
        self.movieRecord = movieRecord
    }
    override func main() {
        if isCancelled {
            return
        }
        
        if movieRecord.url.isEmpty {
            movieRecord.state = .failed
            movieRecord.image = UIImage(named: "Failed")
        }
        guard let url = URL(string: "https:image.tmdb.org/t/p/w500\(movieRecord.url)") else {return}
        
        guard let imageData = try? Data(contentsOf:url) else { return }
        
        if isCancelled {
            return
        }
        if !imageData.isEmpty {
            movieRecord.image = UIImage(data:imageData)
            movieRecord.state = .downloaded
        } else {
            movieRecord.state = .failed
            movieRecord.image = UIImage(named: "Failed")
        }
    }
}


