//
//  Movie.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 5/30/21.
//

import Foundation

struct Movie: Codable {
    
    let backdropURLString: String
    let cast: [Person]
    let mpaaRating: String
//    let director: String
    let genres: [Genre]
    let id: String
    let imdbRating: Double
    //    let length: DateInterval
    // Can live with this as a string for now, since it's only displayed.
    let lengthString: String
    let overview: String
    let posterURLString: String
    let releaseDate: Date
    let slug: String
    let title: String
    
    static let posterPlaceholderName = "film"
    
    private enum CodingKeys: String, CodingKey {
        case backdropURLString = "backdrop"
        case cast
        case mpaaRating = "classification"
//        case director
        case genres
        case id
        case imdbRating = "imdb_rating"
        case lengthString = "length"
        case overview
        case posterURLString = "poster"
        case releaseDate = "released_on"
        case slug
        case title
    }
    
    func releaseYearString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.setLocalizedDateFormatFromTemplate("yyyy")
        let result = formatter.string(from: releaseDate)
        return result
    }
}
