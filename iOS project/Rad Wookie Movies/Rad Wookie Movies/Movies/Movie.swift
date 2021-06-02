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
    let imdb_rating: Decimal?
    let length: DateInterval?
    let overview: String?
    let poster: String?
    let released_on: Date?
    let slug: String?
    let title: String?
    
}
