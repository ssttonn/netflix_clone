//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 23/02/2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject{
    func searchResultsViewControllerDidTapCell(_ searchResultsViewController: SearchResultsViewController, viewModel: MoviePreviewViewModel)
}

class SearchResultsViewController: UIViewController {

    var movies: [Movie] = [Movie]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    var searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchCollectionView)
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieTitle = movie.title ?? movie.original_title ?? movie.name, let movieOverview = movie.overview else {
            return
        }
        
        APICaller.shared.searchYoutubeTrailer(withName: movieTitle) { result in
            switch result{
            case .success(let youtubeMovieElement):
                DispatchQueue.main.async {
                    self.delegate?.searchResultsViewControllerDidTapCell(self, viewModel: MoviePreviewViewModel(title: movieTitle, overview: movieOverview, youtubeVideoElement: youtubeMovieElement))
                }
            case .failure(let error):
                print(error)
            }
        }
        
       
    }
}

extension SearchResultsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.configure(with: movies[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
}
