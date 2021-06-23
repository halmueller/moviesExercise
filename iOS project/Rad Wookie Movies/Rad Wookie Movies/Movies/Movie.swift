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
    let directors: [Person]
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
        case directors = "director"
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backdropURLString = try container.decode(String.self, forKey: .backdropURLString)
        cast = try container.decode([Person].self, forKey: .cast)
        mpaaRating = try container.decode(String.self, forKey: .mpaaRating)
        // API returns "directors" encoded as either a single sting, or an array of strings.
        do {
            let singleDirector = try container.decode(Person.self, forKey: .directors)
            directors = [singleDirector]
        } catch {
            directors = try container.decode([Person].self, forKey: .directors)
        }
        genres = try container.decode([Genre].self, forKey: .genres)
        id = try container.decode(String.self, forKey: .id)
        imdbRating = try container.decode(Double.self, forKey: .imdbRating)
        lengthString = try container.decode(String.self, forKey: .lengthString)
        overview = try container.decode(String.self, forKey: .overview)
        posterURLString = try container.decode(String.self, forKey: .posterURLString)
        releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        slug = try container.decode(String.self, forKey: .slug)
        title = try container.decode(String.self, forKey: .title)
    }

    private static var movieDateFormatter :DateFormatter = {
        let result = DateFormatter()
        result.timeStyle = .none
        result.setLocalizedDateFormatFromTemplate("yyyy")
        return result
    }()
    
    func releaseYearString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.setLocalizedDateFormatFromTemplate("yyyy")
        let result = formatter.string(from: releaseDate)
        return result
    }
}
