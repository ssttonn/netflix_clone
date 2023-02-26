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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider: {_ in
            let downloadAction = UIAction(title: "Download") { _ in
                print("Downloaded")
            }
            return UIMenu(children: [downloadAction])
        })
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        let movie = upcomingMovies[indexPath.row]
        
        guard let title = movie.title ?? movie.original_title ?? movie.name, let movieOverview = movie.overview else {
            return
        }
        
        APICaller.shared.searchYoutubeTrailer(withName: title) { result in
            switch result{
            case .success(let youtubeVideoElement):
                DispatchQueue.main.async {
                    let vc = MoviePreviewViewController()
                    
                    vc.configure(with: MoviePreviewViewModel(title: title, overview: movieOverview, youtubeVideoElement: youtubeVideoElement))
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        
      
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
