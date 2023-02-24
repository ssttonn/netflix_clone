//
//  UpcomingMovieTableViewCell.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 20/02/2023.
//

import UIKit

class CommonMovieTableViewCell: UITableViewCell {
    static let identifier = "UpcomingMovieTableViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moviePlayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(moviePlayButton)
        
        applyConstraints()
    }
    
    private func applyConstraints(){
        let postImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(postImageViewConstraints)
        
        let movieNameLabelConstraints = [
            movieNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 14),
            movieNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(movieNameLabelConstraints)
        
        let moviePlayButtonConstraints = [
            moviePlayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moviePlayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(moviePlayButtonConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(movieViewModel: MovieViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movieViewModel.posterURL)") else {return}
        movieNameLabel.text = movieViewModel.titleName
        posterImageView.sd_setImage(with: url)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
