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

class APIManager : NSObject, URLSessionDelegate {
    
    private let baseURLString = "https://wookie.codesubmit.io/movies/"
    
    private let authenticationHeaderString = "Authorization: Bearer Wookie2019"
    
    private let searchQueryKey = "q"

    private func moviesListURL () -> URL {
        let result = URL(string: baseURLString)!
        return result
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
