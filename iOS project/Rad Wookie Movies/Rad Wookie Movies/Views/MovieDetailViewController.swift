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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let movie = movie {
            print(movie.title)
            titleLabel?.text = movie.title + "(" + movie.mpaaRating + ")"
            lengthLabel?.text = movie.lengthString
            yearLabel?.text = movie.releaseDateString
            castLabel?.text = "cast:" + movie.cast.joined(separator: ", ")
            movieOverviewTextView?.text = movie.overview
            configureRatingStars()
            
            poster?.image = UIImage(systemName: Movie.posterPlaceholderName, withConfiguration: UIImage.SymbolConfiguration(scale: .large))

            if let backdropUrl = URL(string: movie.backdropURLString) {
                apiManager?.fetchImage(url: backdropUrl) { [weak self] (fetchedImage) in
                    if let self = self {
                        self.backdrop?.image = fetchedImage
                    }
                }
            }
            
            if let posterUrl = URL(string: movie.posterURLString) {
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
                // IMDB scores 0-10, but we show 1-5 stars
                let stars = movie.imdbRating / 2
                let fullStars = stars.rounded(.down)
                print(movie.title, movie.imdbRating, fullStars, stars)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
