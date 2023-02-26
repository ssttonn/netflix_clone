//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 12/02/2023.
//

import UIKit

enum Section: Int{
    case trendingMovies
    case trendingTvs
    case popular
    case upcoming
    case topRated
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = [
        "Trending Movies",
        "Trending TV",
        "Popular",
        "Upcoming Movies",
        "Top rated"
    ]
    
    private var headerMovie: Movie?
    
    private var headerView: HeroHeaderUIView? = nil
    
    private let homeFeedTable: UITableView = {
        // init a UITableView
        let table = UITableView(frame: .zero, style: .grouped)
        
        // Register CollectionViewTable
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(homeFeedTable)
        
        // set up delegation and datasource for UITableView
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        self.headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the UICollectionView's frame equal to its parent content size
        homeFeedTable.frame = view.bounds
        
    }
    
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x+20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Find UITableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section{
        case Section.trendingMovies.rawValue:
            APICaller.shared.getTrendingMovies {result in
                switch result{
                case .success(let movies):
                    self.headerMovie = movies.randomElement()
                    
                    self.headerView?.configure(with: MovieViewModel(titleName: self.headerMovie?.title ?? self.headerMovie?.original_title ?? self.headerMovie?.name ?? "Unknown", posterURL: self.headerMovie?.poster_path ?? ""))
                    cell.configure(movies: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.trendingTvs.rawValue:
            APICaller.shared.getTrendingTvs {result in
                switch result{
                case .success(let movies):
                    cell.configure(movies: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.popular.rawValue:
            APICaller.shared.getPopularMovies{result in
                switch result{
                case .success(let movies):
                    cell.configure(movies: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.upcoming.rawValue:
            APICaller.shared.getUpcomingMovies{result in
                switch result{
                case .success(let movies):
                    cell.configure(movies: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.topRated.rawValue:
            APICaller.shared.getTopRatedMovies{result in
                switch result{
                case .success(let movies):
                    cell.configure(movies: movies)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            break
        }
        
        return cell
        
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async {
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
