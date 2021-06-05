//
//  Movie.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 5/30/21.
//

import Foundation

struct Movie: Codable {
    
    let backdropURLString: String?
    let cast: [String]
    let classification: String?
//    let director: String?
    let genres: [Genre]
    let id: String?
    let imdbRating: Decimal?
    //    let length: DateInterval?
    let lengthString: String
    let overview: String?
    let posterURLString: String?
//    let releaseDate: Date?
    let releaseDateString: String?
    let slug: String?
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case backdropURLString = "backdrop"
        case cast
        case classification
//        case director
        case genres
        case id
        case imdbRating = "imdb_rating"
//        case length
        case lengthString = "length"
        case overview
        case posterURLString = "poster"
//        case releaseDate = "released_on"
        case releaseDateString = "released_on"
        case slug
        case title
    }
    
}
