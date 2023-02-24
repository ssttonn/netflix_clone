//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 12/02/2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    private let discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommonMovieTableViewCell.self, forCellReuseIdentifier: CommonMovieTableViewCell.identifier)
        return tableView
    }()
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(discoverTableView)
        
        
        view.backgroundColor = .systemBackground
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
        APICaller().getDiscoverMovies{ result in
            switch result{
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonMovieTableViewCell.identifier, for: indexPath) as? CommonMovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = self.movies[indexPath.row]
        
        cell.configure(movieViewModel: MovieViewModel(titleName: movie.title ?? "Unknown", posterURL: movie.poster_path ?? ""))
        return cell
    }
    
 
}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count > 3 else{
            return
        }
        
        guard let searchResultController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        APICaller.shared.search(query: query) { result in
            switch result{
            case .success(let movies):
                searchResultController.movies = movies
                DispatchQueue.main.async {
                    searchResultController.searchCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
