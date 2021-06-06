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
            titleLabel?.text = movie.title
            lengthLabel?.text = movie.lengthString
            yearLabel?.text = movie.releaseDateString
            castLabel?.text = "cast:" + movie.cast.joined(separator: ", ")
            movieOverviewTextView?.text = movie.overview
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
