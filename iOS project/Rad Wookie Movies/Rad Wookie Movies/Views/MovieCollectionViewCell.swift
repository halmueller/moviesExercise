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
    
    func load(_ movie: Movie) {

        title?.text = movie.title
        poster?.image = UIImage(systemName: "film", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        
        // from inspection: most images are 342x513. Some are 488 or 507 pixels tall. 342 seems to be constant width.
        if let posterUrl = URL(string: movie.posterURLString) {
            apiManager?.fetchImage(url: posterUrl) { [weak self] (fetchedImage) in
                if let self = self {
                    self.poster?.image = fetchedImage
                }
            }
        }
    }
    
    private func loadPosterFromURLString(_ urlString: String) {
        print(urlString)
    }
}
