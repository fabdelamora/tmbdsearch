//
//  MovieListViewController.swift
//  Movies
//
//  Created by Fabriccio De la Mora on 3/7/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    private var detailViewController: MovieDetailViewController? = nil
    private lazy var movies = [Movie]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var noResults = false
    private let movieFetch = MovieFetch()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MovieDetailViewController
        }
        
        self.tableView.alpha = 0.0
        
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        self.fetchTopMovies()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Movies fetch
    
    private func fetchTopMovies() {
        self.movieFetch.getMovies(success: { [unowned self] (movies) in
            self.movies = movies
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.25, animations: {
                self.tableView.alpha = 1.0
            })
        })
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = movies[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! MovieDetailViewController
                controller.movie = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableViewCell

        let object = movies[indexPath.row]
        
        cell.title.text = object.title
        
        if !noResults {
            cell.backgroundImage.sd_setImage(with: movieFetch.posterUrlForResource(object.posterPath, width:500),
                                             placeholderImage: nil,
                                             options: []) { (image, error, imageCacheType, imageUrl) in
                                                UIView.animate(withDuration: 0.25, animations: {
                                                    cell.backgroundImage.alpha = 0.25
                                                })
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        splitViewController?.collapseSecondaryViewController(self, for: splitViewController!)
    }
    
    // MARK: - Search Controller
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if (searchBar.text != nil) || searchBar.text != "" {
            self.movieFetch.searchMovie(searchBar.text!) { [unowned self] (movies) in
                if movies.count > 0 {
                    self.movies = movies
                    self.noResults = false
                } else {
                    self.noResults = true
                    self.movies = self.movieFetch.noResultsList()
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.noResults = false
        self.fetchTopMovies()
    }
}

class MovieTableViewCell: UITableViewCell {
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundImage.image = nil
    }
}
