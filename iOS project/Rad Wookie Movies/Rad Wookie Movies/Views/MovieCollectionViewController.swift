//
//  MovieCollectionViewController.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/3/21.
//

import UIKit

private let reuseIdentifier = "MovieCell"
private let headerReuseIdentifier = "header"

class MovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var apiManager: APIManager?
    
    var movies: [Movie] = [] {
        didSet {
            updateGenres()
            collectionView.reloadData()
        }
    }
    var moviesByGenre: [Genre : [Movie]] = [:]
    var genres: [Genre] = []
    
    func updateGenres() {
        moviesByGenre = [:]
        genres = Array(Set(movies.flatMap  {$0.genres})).sorted()
        for genre in genres {
            let matchingMovies = movies.filter( {$0.genres.contains(genre)} ).sorted(by: {$0.title < $1.title})
            moviesByGenre[genre] = matchingMovies
        }
    }

    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isAccessibilityElement = false
        collectionView.shouldGroupAccessibilityChildren = true
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            configureFlowLayout(layout)
        }
        
        apiManager?.fetchMovies() { [weak self] (foundMovies) in
            if let foundMovies = foundMovies,
               let self = self {
                self.movies = foundMovies
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    func configureFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {
        flowLayout.sectionHeadersPinToVisibleBounds = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
            destination.apiManager = apiManager
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! MovieCollectionViewHeader
            header.genreLabel.text = genres[indexPath.section]
            header.accessibilityLabel = header.genreLabel.text
            header.accessibilityHint = "Genre"
            header.isAccessibilityElement = true
            header.shouldGroupAccessibilityChildren = true
            return header
        default:
            print(#function, "fell through")
            return UICollectionReusableView()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(genres.count)
        return genres.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moviesInSection = moviesByGenre[genres[section]] else { return 0 }
        return moviesInSection.count
    }

    func movie(indexPath: IndexPath) -> Movie? {
        guard let moviesInSection = moviesByGenre[genres[indexPath.section]] else { return nil }
        let movie = moviesInSection[indexPath.row]
        return movie
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        if let movie = movie(indexPath: indexPath) {
            cell.apiManager = apiManager
            cell.load(movie)
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(#function, indexPath)
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath)
        selectedMovie = movie(indexPath: indexPath)
        performSegue(withIdentifier: "showMovieDetail", sender: self)
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
}

