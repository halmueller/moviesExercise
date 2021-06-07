//
//  TabBarController.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/3/21.
//

import UIKit

class TabBarController: UITabBarController {

    let apiManager = APIManager()
    var movieCollectionViewController: MovieCollectionViewController?
    var searchViewController: SearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var newViewControllers : [UIViewController] = []

        let movieCollectionStoryboard = UIStoryboard.init(name: "MovieCollectionViewController", bundle: nil)
        if let movieCollectionViewController = movieCollectionStoryboard.instantiateInitialViewController() as? MovieCollectionViewController {
            movieCollectionViewController.apiManager = apiManager
            self.movieCollectionViewController = movieCollectionViewController
            if let homeImage = UIImage.init(systemName: "house.fill") {
                movieCollectionViewController.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeImage)
            }
            newViewControllers.append(movieCollectionViewController)
        }
        
        let searchStoryboard = UIStoryboard.init(name: "SearchViewController", bundle: nil)
        if let searchViewController = searchStoryboard.instantiateInitialViewController() as? SearchViewController {
            searchViewController.apiManager = apiManager
            self.searchViewController = searchViewController
            if let searchImage = UIImage.init(systemName: "magnifyingglass") {
                searchViewController.tabBarItem = UITabBarItem(title: "Search", image: searchImage, selectedImage: searchImage)
            }
            newViewControllers.append(searchViewController)
        }

        viewControllers = newViewControllers
        selectedIndex = 1
        
    }
    

    // MARK: - Navigation

}
