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
    
    var searchController = UISearchController(searchResultsController: nil)
    
    struct CollectionViewCellIdentifiers {
        static let favMovieCell = "FavoriteMovieCollectionViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Collection View
        collectionView.register(UINib(nibName: CollectionViewCellIdentifiers.favMovieCell, bundle: .main), forCellWithReuseIdentifier: CollectionViewCellIdentifiers.favMovieCell)
        
       setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.definesPresentationContext = true
    }
    
    func setupNavigationBar() {
    //    searchController.searchBar.delegate = self as! UISearchBarDelegate
   //     searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
        searchController.searchBar.placeholder = "Search Movie"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
    }
    
    func retrieveData() {
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
        
            retrieveData()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifiers.favMovieCell, for: indexPath) as! FavoriteMovieCollectionViewCell
        
            let fav = favMovies.favMovies[indexPath.row]
        
            cell.configure(for: (fav ?? nil)!)
            cell.layoutIfNeeded()
            return cell
        
    }
    
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let movieDetail = MovieDetailViewController()
        movieDetail.selectedFavMovie? = favMovies.favMovies[indexPath.row]
        
     performSegue(withIdentifier: "MovieDetail", sender: indexPath)
     
     }
     
     // MARK: -Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "MovieDetail" {

     let detailViewController = segue.destination as! MovieDetailViewController
     let indexPath = sender as! IndexPath
     let fav = favMovies.favMovies[indexPath.row]
     detailViewController.selectedFavMovie = fav
        print(detailViewController.selectedFavMovie)
     }
    }
}

