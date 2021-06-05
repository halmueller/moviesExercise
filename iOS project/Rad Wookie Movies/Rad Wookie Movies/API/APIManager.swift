//
//  APIManager.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/1/21.
//

import Foundation
// TODO: figure out how to remove UIKit/UIImage dependency
import UIKit

protocol APIMovieFetchResultsDelegate {
    // TODO: wrap the response and error code in the result
    func apiManagerMovieFetchDidFinish(_ apiManager: APIManager, request: URLRequest, result: [Movie]?)
}

protocol APIImageFetchResultsDelegate {
    // TODO: wrap the response and error code in the result
    func apiManagerImageFetchDidFinish(_ apiManager: APIManager, request: URLRequest, result: UIImage?)
}

class APIManager : NSObject {
    
    private let baseURLString = "https://wookie.codesubmit.io"
    
    private let authenticationHeaderDict = ["Authorization" : "Bearer Wookie2019"]
    
    private let searchQueryKey = "q"
    
    private lazy var urlSession : URLSession = {
        let config = URLSessionConfiguration.default
        
        // Quinn said this was ok: https://developer.apple.com/forums/thread/89811
        config.httpAdditionalHeaders = authenticationHeaderDict
        
        let result = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        return result
    }()

    private func moviesListURL () -> URL {
        let result = URL(string: "\(baseURLString)/movies")!
        return result
    }
    
    private func moviesListURL1 () -> URL {
        let result = URL(string: "\(baseURLString)/movies")!
        return result
    }
    
    func fetchMovies (completionHandler: @escaping ([Movie]?) -> Void) {
//        let movie1 = Movie(backdrop: "backdrop", cast: ["one", "two"], classification: "abc", genres: ["a"], id: "asdf", imdbRating: 0, lengthString: "1:23", overview: "", poster: "", releaseDate: Date(), slug: "", title: "title 1")
//        let movies = MoviesServerPayload(movies: [movie1])
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//        do {
//            let json = try encoder.encode(movies)
//            print(String(data: json, encoding: .utf8))
//        } catch {
//            print(error)
//        }
        


        let task = urlSession.dataTask(with: moviesListURL()) {(data, response, error ) in
            guard error == nil else {
                print("guard returned error", error as Any)
                return
            }
            guard let content = data else {
                print("No data")
                return
            }
            print(content)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            print(decoder.dateDecodingStrategy)
            do {
                let movies = try decoder.decode(MoviesServerPayload.self, from: content)
                completionHandler(movies.movies)
            }
            catch {
                print("Failed to decode JSON")
                print(error)
            }
  
        }

       task.resume()
    }
        
    func moviesListRequest () -> URLRequest {
        let result = URLRequest(url: moviesListURL())
        
        return result
    }
    
    func searchRequest(_ string: String) -> URLRequest {
        let result = URLRequest(url: moviesListURL())
        
        return result
    }
    
}

extension APIManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function, session, challenge)
        print(challenge.proposedCredential)
        print(challenge.protectionSpace)
        print(challenge.protectionSpace.authenticationMethod)
//        let credential = URLCredential(trust: SecTrust(authenticationHeaderString: "Bearer Wookie2019"))
    }
}

extension APIManager: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?)  -> Void) {
        //
        //        func urlSession(_ session: URLSession, task: USURLSe didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function, session, challenge)
        print(challenge.proposedCredential)
    }
    
}
