//
//  MovieDetailViewController.swift
//  BTG
//
//  Created by Gustavo Quenca on 24/04/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var downloadTask: URLSessionDownloadTask?
    
    private let dataSource = DataSource()
    
    var movieList: Movie!
    
    var selectedMovie: Movie? {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    enum FavoriteState {
        case favorite
        case notFavorite
    }
    
    var favMovie: [Movie?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedMovie != nil {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.text = selectedMovie?.title!
        yearLabel.text = selectedMovie?.release_date!
        
        dataSource.getGenreRequest(completion: { success in
            if !success {
                print("error")
            }
            if case .genreResults(let list) = self.dataSource.genreState {
                for i in 0..<list.count {
                    if (self.selectedMovie!.genre_ids?.contains(list[i].id!))! {
                        self.genreLabel.text = list[i].name
                    }
                }
            }
        })
        
        overviewLabel.text = selectedMovie?.overview!
        if let posterPath = selectedMovie?.poster_path {
            let urlImage = "https://image.tmdb.org/t/p/w200\(posterPath)"
            print(urlImage)
            posterImage.image = UIImage(named: urlImage)
            if let smallURL = URL(string: urlImage) {
                downloadTask = posterImage.loadImage(url: smallURL)
                print("Poster is \(smallURL)")
            }
        }
    }
}




