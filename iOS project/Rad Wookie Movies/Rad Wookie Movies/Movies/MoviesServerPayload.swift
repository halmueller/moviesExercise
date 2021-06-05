//
//  MoviesServerPayload.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/4/21.
//

import Foundation

struct MoviesServerPayload : Codable {
    let movies: [Movie]
}
