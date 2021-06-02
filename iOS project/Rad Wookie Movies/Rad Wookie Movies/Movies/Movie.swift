//
//  Movie.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 5/30/21.
//

import Foundation

struct Movie: Decodable {
    
    let backdrop: String?
    let cast: [Person]
    let classification: String?
    let director: Person?
    let genres: [Genre]
    let id: String?
    let imdbRating: Decimal?
    let length: DateInterval?
    let overview: String?
    let poster: String?
    let releaseDate: Date?
    let slug: String?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case backdrop
        case cast
        case classification
        case director
        case genres
        case id
        case imdbRating = "imdb_rating"
        case length
        case overview
        case poster
        case releaseDate = "released_on"
        case slug
        case title
    }
    
}