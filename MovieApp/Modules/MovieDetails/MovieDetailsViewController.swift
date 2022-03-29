//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Admin on 29/03/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var overViewLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var viewModel: MovieDetialsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    func setupUI() {
        self.imageView.image = viewModel.movieRecord.image
        self.movieNameLbl.text = viewModel.movieRecord.name
        self.overViewLbl.text = viewModel.movieRecord.overView
    }

}
