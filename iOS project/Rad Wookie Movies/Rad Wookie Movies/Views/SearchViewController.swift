//
//  SearchViewController.swift
//  Rad Wookie Movies
//
//  Created by Hal Mueller on 6/6/21.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating {

    var apiManager: APIManager?
    var foundMovies: [Movie] = [] {
        didSet {
            print(#function, foundMovies.count, tableView)
            tableView.reloadData()
        }
    }

    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearch()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath)

        cell.textLabel?.text = foundMovies[indexPath.row].title

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
            destination.apiManager = apiManager
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, indexPath)
        selectedMovie = foundMovies[indexPath.row]
        
        performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
    
    // MARK: - search bar
    
    func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a movie title or description"
        searchController.searchBar.showsSearchResultsButton = true
        tableView.addSubview(searchController.searchBar)
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        print(#function, searchController.searchBar.text)
        if let searchText = searchController.searchBar.text {
            apiManager?.fetchMoviesForTitleQuery(searchText) { [weak self] (foundMovies) in
                if let foundMovies = foundMovies,
                   let self = self {
                    self.foundMovies = foundMovies.sorted(by: {$0.title < $1.title})
                }
            }
        }
    }
    
}
