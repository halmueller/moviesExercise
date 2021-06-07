//
//  APIManager.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/1/21.
//

import Foundation
// TODO: figure out how to remove UIKit/UIImage dependency
import UIKit

class APIManager : NSObject {
    
    private let baseURLString = "https://wookie.codesubmit.io"
    
    private let authenticationHeaderDict = ["Authorization" : "Bearer Wookie2019"]
    
    private let searchQueryKey = "q"
    
    private let decoder = JSONDecoder()
    
    private lazy var movieDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        // omit the trailing Z for UTC timezone because that's what the server sends us.
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    override init() {
        decoder.dateDecodingStrategy = .iso8601
        super.init()
    }

    private lazy var urlSession : URLSession = {
        let config = URLSessionConfiguration.default
        
        // Per documentation, we're not allowed to insert an authentication header. But Quinn said this was ok: https://developer.apple.com/forums/thread/89811
        config.httpAdditionalHeaders = authenticationHeaderDict
        
        let result = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        return result
    }()

    private func moviesListURL () -> URL {
        let result = URL(string: "\(baseURLString)/movies")!
        return result
    }
    
    private func moviesQueryURL (_ searchText: String) -> URL? {
        if let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let urlString = "\(baseURLString)/movies?q=\(encodedSearchText))"
            let result = URL(string: urlString)!
            return result
        }
        return nil
    }

    // TODO: refactor the two fetchMovies... functions into one, with a parameter
    func fetchMoviesForTitleQuery(_ searchText: String, completionHandler: @escaping ([Movie]?) -> Void) {
        if let queryURL = moviesQueryURL(searchText) {
            let task = urlSession.dataTask(with: queryURL) { [weak self] (data, response, error ) in
                guard error == nil else {
                    print(#function, "returned error", error as Any)
                    return
                }
                guard let content = data else {
                    print(#function, "No data")
                    return
                }
                
                guard let self = self else { return }
                
                do {
                    let moviesPayload = try self.decodedMoviesPayload(content)
                    DispatchQueue.main.async {
                        if let moviesPayload = moviesPayload {
                            completionHandler(moviesPayload.movies)
                        } else {
                            completionHandler(nil)
                        }
                    }
                }
                catch {
                    print(#function, "Failed to decode JSON")
                    print(error)
                }
            }
            task.resume()
        }
        else {
            let emptyMovies = [Movie]()
            completionHandler(emptyMovies)
        }
    }
    
    fileprivate func decodedMoviesPayload(_ content: Data) throws -> MoviesServerPayload? {
        do {
            self.decoder.dateDecodingStrategy = .formatted(self.movieDateFormatter)
            let moviesPayload = try self.decoder.decode(MoviesServerPayload.self, from: content)
            return moviesPayload
        }
        catch {
            print(#function, "Failed to decode JSON")
            throw error
        }
    }
    
    func fetchMovies (completionHandler: @escaping ([Movie]?) -> Void) {

        let task = urlSession.dataTask(with: moviesListURL()) { [weak self] (data, response, error ) in
            guard error == nil else {
                print(#function, "returned error", error as Any)
                return
            }
            guard let content = data else {
                print(#function, "No data")
                return
            }

            guard let self = self else { return }
            
            do {
                let moviesPayload = try self.decodedMoviesPayload(content)
                DispatchQueue.main.async {
                    if let moviesPayload = moviesPayload {
                        completionHandler(moviesPayload.movies)
                    } else {
                        completionHandler(nil)
                    }
                }
            }
            catch {
                print(#function, "Failed to decode JSON")
                print(error)
            }
  
        }

       task.resume()
    }
        
    func fetchImage (url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        let task = urlSession.dataTask(with: url)  {(data, response, error ) in
            guard error == nil else {
                print(#function, "returned error", error as Any)
                return
            }
            guard let content = data else {
                print(#function, "No data")
                return
            }
            let image = UIImage(data: content)
            DispatchQueue.main.async {
                completionHandler(image)
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
