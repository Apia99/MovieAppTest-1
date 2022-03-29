//
//  CustomTableViewCells.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "MovieDetailsTableViewCell"

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favButton_: UIButton!
    
    override func prepareForReuse() {
        self.movieImageView.image = nil
    }
    func configureCell(movieRecord:MovieRecord) {
        titleLabel.text = movieRecord.name
        overviewLabel.text = movieRecord.overView
    }
    
    
////    @IBAction func favButton(_ sender: UIButton) { print("Item #\(sender.tag) was selected as a favorite")
//    }
    
}


        
