//
//  MovieRecord.swift
//  MovieApp
//
//  Created by Admin on 29/03/22.
//

import Foundation
import UIKit

enum MovieRecordState {
  case new, downloaded, failed
}

class MovieRecord {
    let name: String
    let url: String
    let overView: String
    var state = MovieRecordState.new
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:String, overView: String) {
        self.name = name
        self.url = url
        self.overView = overView
    }
}
