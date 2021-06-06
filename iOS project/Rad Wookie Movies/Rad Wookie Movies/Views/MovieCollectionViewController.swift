//
//  MovieCollectionViewController.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/3/21.
//

import UIKit

private let reuseIdentifier = "MovieCell"
private let headerReuseIdentifier = "header"

class MovieCollectionViewController: UICollectionViewController {

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
        
        apiManager?.fetchMovies() { [weak self] (foundMovies) in
            if let foundMovies = foundMovies,
               let self = self {
                self.movies = foundMovies
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! MovieCollectionViewHeader
            header.genreLabel.text = genres[indexPath.section]
            return header
        default:
            print(#function, "fell through")
            return UICollectionReusableView()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
        }
    }

    // MARK: UICollectionViewDataSource

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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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

}

