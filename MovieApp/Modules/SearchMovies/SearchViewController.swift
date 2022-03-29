//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SearchViewModel()
    private var subscribers = Set<AnyCancellable>()
    let pendingOperations = PendingOperations()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpBinding()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let movieRecored = sender as! MovieRecord
        let destination = segue.destination as? MovieDetailsViewController
        destination?.viewModel = MovieDetialsViewModel(movieRecord: movieRecored)
    }
    
    private func setUpUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    private func setUpBinding() {
        viewModel
            .$movies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.showActivityIndicator(isShow: false)
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
        
        publisher
            .map {
                ($0.object as! UISearchTextField).text!
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] searchedText in
                self?.viewModel.searchMovies(searchedText: searchedText)
                self?.showActivityIndicator(isShow: true)
            }.store(in: &subscribers)
    }
    
    private func showActivityIndicator(isShow:Bool) {
        activityIndicator.isHidden = !isShow
        isShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        tableView.isHidden = isShow
    }
    
    func startDownload(for movieRecord: MovieRecord, at indexPath: IndexPath) {
      guard pendingOperations.downloadsInProgress[indexPath] == nil else {
        return
      }
      
      let downloader = ImageDownloader(movieRecord)
      downloader.completionBlock = {
        if downloader.isCancelled {
          return
        }
        
        DispatchQueue.main.async {
          self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
            
          self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
      }
      pendingOperations.downloadsInProgress[indexPath] = downloader
      pendingOperations.downloadQueue.addOperation(downloader)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsTableViewCell.identifier, for: indexPath) as? MovieDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        let movieRecord = viewModel.movieRecords[indexPath.row]
        
        cell.configureCell(movieRecord: movieRecord)

        switch (movieRecord.state) {
       
        case .failed:
            print("Failed to download image")
        case .new :
              startDownload(for: movieRecord, at: indexPath)
          
        case .downloaded :
            cell.movieImageView.image = movieRecord.image
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let movieRecord = viewModel.movieRecords[indexPath.row]
        performSegue(withIdentifier: "showDeatilView", sender: movieRecord)
    }
}


