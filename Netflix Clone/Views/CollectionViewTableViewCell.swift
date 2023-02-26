//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 12/02/2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = [Movie]()
    
    private let movieCollectionView: UICollectionView = {
        // Create a layout for UICollectionView
        let layout = UICollectionViewFlowLayout()
        
        // Set each item width and height
        layout.itemSize = CGSize(width: 140, height: 200)
        
        // Set main scrollDirection for UICollectionView
        layout.scrollDirection = .horizontal
        
        // Create a UICollectionView with zero frame and layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Register default UICollectionViewCell for UICollectionView
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // set background to orange
        contentView.backgroundColor = .systemOrange
        
        // add collectionView as subview of the contentView
        contentView.addSubview(movieCollectionView)
        
        // set up delegation and datasource for UICollectionView
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the UICollectionView's frame equal to its parent content size
        movieCollectionView.frame = contentView.bounds
    }
    
    func configure(movies: [Movie]){
        self.movies = movies
        DispatchQueue.main.sync {
            self.movieCollectionView.reloadData()
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ _ in
            let downloadAction = UIAction(title: "Download") { _ in
                print("download tapped")
            }
            
            return UIMenu(children: [downloadAction])
        }
        return config
    }
}

extension CollectionViewTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Find UICollectionViewCell
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        let movieName = movie.title ?? movie.original_title
        
        guard let movieName = movieName else{
            return
        }
        
        APICaller.shared.searchYoutubeTrailer(withName: movieName) { result in
            switch result{
            case .success(let movieTrailerElement):
                self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: MoviePreviewViewModel(title: movieName, overview: movie.overview ?? "", youtubeVideoElement: movieTrailerElement))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
