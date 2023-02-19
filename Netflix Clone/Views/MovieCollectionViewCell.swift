//
//  MovieCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 19/02/2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = bounds
    }
    
    func configure(with movie: Movie){
        guard let posterPath = movie.poster_path else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else {return}
        posterImageView.sd_setImage(with: url)
    }
}
