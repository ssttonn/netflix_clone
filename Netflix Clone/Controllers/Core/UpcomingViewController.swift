//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 12/02/2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var upcomingMovies: [Movie] = [Movie]()
    
    private let upcomingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommonMovieTableViewCell.self, forCellReuseIdentifier: CommonMovieTableViewCell.identifier)
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(upcomingTableView)
        
        title = "Upcoming"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    
  
    
    private func fetchUpcomingMovies(){
        APICaller.shared.getUpcomingMovies{ result in
            switch result{
            case .success(let movies):
                self.upcomingMovies = movies
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension UpcomingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension UpcomingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonMovieTableViewCell.identifier, for: indexPath) as? CommonMovieTableViewCell else {return UITableViewCell()}
        cell.configure(movieViewModel: MovieViewModel(titleName: upcomingMovies[indexPath.row].name ?? upcomingMovies[indexPath.row].original_title ?? upcomingMovies[indexPath.row].title ?? "Unknown name", posterURL: upcomingMovies[indexPath.row].poster_path ?? ""))
        return cell
    }
    
    
}
