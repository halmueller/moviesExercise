//
//  MovieDetailViewController.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/3/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var apiManager: APIManager?

    var movie: Movie? = nil
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backdrop: UIImageView!
    
    
    @IBOutlet var ratingStarViews: [UIImageView]?
    @IBOutlet weak var ratingStarStackview: UIStackView!
    @IBOutlet var star1: UIImageView?
    @IBOutlet var star2: UIImageView?
    @IBOutlet var star3: UIImageView?
    @IBOutlet var star4: UIImageView?
    @IBOutlet var star5: UIImageView?

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var lengthLabel: UILabel?
    @IBOutlet weak var directorsLabel: UILabel?
    @IBOutlet weak var yearLabel: UILabel?
    @IBOutlet weak var castLabel: UILabel?
    @IBOutlet weak var movieOverviewTextView: UITextView?
   
    override func viewWillAppear(_ animated: Bool) {
        if let movie = movie {
            titleLabel?.text = movie.title + "(" + movie.mpaaRating + ")"
            lengthLabel?.text = movie.lengthString
            lengthLabel?.accessibilityLabel = "Running time \(movie.lengthString)"
            yearLabel?.text = movie.releaseDateString
            yearLabel?.accessibilityLabel = "Released \(movie.lengthString)"
            directorsLabel?.text = "directors"
            directorsLabel?.accessibilityLabel = "Directed by directors"
            castLabel?.text = "cast: " + movie.cast.joined(separator: ", ") + "."
            movieOverviewTextView?.text = movie.overview
            configureRatingStars()
            
            poster?.image = UIImage(systemName: Movie.posterPlaceholderName, withConfiguration: UIImage.SymbolConfiguration(scale: .large))

            if let backdropUrl = URL(string: movie.backdropURLString) {
                backdrop?.accessibilityLabel = "backdrop"
                backdrop?.isAccessibilityElement = true
                apiManager?.fetchImage(url: backdropUrl) { [weak self] (fetchedImage) in
                    if let self = self {
                        self.backdrop?.image = fetchedImage
                    }
                }
            }
            
            if let posterUrl = URL(string: movie.posterURLString) {
                poster?.accessibilityLabel = "poster"
                poster?.isAccessibilityElement = true
                apiManager?.fetchImage(url: posterUrl) { [weak self] (fetchedImage) in
                    if let self = self {
                        self.poster?.image = fetchedImage
                    }
                }
            }
        }
    }
    
    func configureRatingStars() {
        if let ratingStarViews = ratingStarViews {
            let filledStar = UIImage(systemName: "star.fill")
            let openStar = UIImage(systemName: "star")
            let partialStar = UIImage(systemName: "star.leadinghalf.fill")
            for starView in ratingStarViews {
                starView.image = filledStar
                starView.tintColor = .systemYellow
            }
            if let movie = movie {
                ratingStarStackview.accessibilityLabel = "IMDB rating \(movie.imdbRating)"
                ratingStarStackview.isAccessibilityElement = true
                        
                // IMDB scores 0-10, but we show 1-5 stars
                let stars = movie.imdbRating / 2
                let fullStars = stars.rounded(.down)
                if fullStars < 5 {
                    star5?.image = stars > 4 ? partialStar : openStar
                }
                if fullStars < 4 {
                    star4?.image = stars > 3 ? partialStar : openStar
                }
                if fullStars < 3 {
                    star3?.image = stars > 2 ? partialStar : openStar
                }
                if fullStars < 2 {
                    star2?.image = stars > 1 ? partialStar : openStar
                }
                if fullStars < 1 {
                    star1?.image = stars > 0 ? partialStar : openStar
                }
            }
        }
    }

}
