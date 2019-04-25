//
//  FavoritesViewController.swift
//  BTG
//
//  Created by Gustavo Quenca on 23/04/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 10.0
    
    var favMovies = MovieDetailViewController()
    
    struct CollectionViewCellIdentifiers {
        static let favMovieCell = "FavoriteMovieCollectionViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Collection View
        collectionView.register(UINib(nibName: CollectionViewCellIdentifiers.favMovieCell, bundle: .main), forCellWithReuseIdentifier: CollectionViewCellIdentifiers.favMovieCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        
        do {
            favMovies.favMovies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: -Setting the Collection Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set up desired width
        let targetWidth: CGFloat = (self.collectionView.bounds.width - 3 * kHorizontalInsets) / 2
        
        // Use fake cell to calculate height
        let reuseIdentifier =  CollectionViewCellIdentifiers.favMovieCell
        var cell: FavoriteMovieCollectionViewCell? = self.offscreenCells[reuseIdentifier] as? FavoriteMovieCollectionViewCell
        if cell == nil {
            if let cells = Bundle.main.loadNibNamed("FavoriteMovieCollectionViewCell", owner: self, options: nil), let c = cells[0] as? FavoriteMovieCollectionViewCell {
                cell = c
                self.offscreenCells[reuseIdentifier] = c
            }
        }
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell!.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: cell!.bounds.height)
        cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell!.layoutIfNeeded()
        
        var size = cell!.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
        //let width = (view.frame.size.width - 10) / 2.0
        //return CGSize(width: width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kVerticalInsets, left: kHorizontalInsets, bottom: kVerticalInsets, right: kHorizontalInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kHorizontalInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kVerticalInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favMovies.favMovies.count
    }
    
    // Mark: -CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.favMovieCell, for: indexPath) as! FavoriteMovieCollectionViewCell
        
            let fav = favMovies.favMovies[indexPath.row]
        
            cell.configure(for: (fav ?? nil)!)
            cell.layoutIfNeeded()
            return cell
        
    }
    

}

