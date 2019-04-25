//
//  MovieCollectionViewCell.swift
//  BTG
//
//  Created by Gustavo Quenca on 24/04/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
    }
    
    // Cancel the pending download
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(for result: Movie) {
        
        titleLabel.text = result.title!
        if let posterPath = result.poster_path {
            let urlImage = "https://image.tmdb.org/t/p/w200\(posterPath)"
            posterImage.image = UIImage(named: urlImage)
            if let smallURL = URL(string: urlImage) {
                downloadTask = posterImage.loadImage(url: smallURL)
                print(smallURL)
            }
        }
    }
}
