//
//  MovieCollectionViewCell.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/5/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var poster: UIImageView?
    @IBOutlet weak var title: UILabel?
    var apiManager: APIManager?
    var movie: Movie?
    
    func load(_ movie: Movie) {
        self.movie = movie
        title?.text = movie.title
        poster?.image = UIImage(systemName: Movie.posterPlaceholderName, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        
        isAccessibilityElement = true
        accessibilityLabel = movie.title
        accessibilityHint = "Movie"
        poster?.isAccessibilityElement = false
        title?.isAccessibilityElement = false
        
        // from inspection: most images are 342x513. Some are 488 or 507 pixels tall. 342 seems to be constant width.
        if let posterUrl = URL(string: movie.posterURLString) {
            let movieId = movie.id
            apiManager?.fetchImage(url: posterUrl) { [weak self] (fetchedImage) in
                if let self = self {
                    // This cell might have been recyled already. Turn on Network Link Conditioner to exercise.
                    if self.movie?.id == movieId {
                        self.poster?.image = fetchedImage
                    } else {
                        print(#function, "skipping", self.movie?.title)
                    }
                }
            }
        }
    }
    
    private func loadPosterFromURLString(_ urlString: String) {
        print(urlString)
    }
}
