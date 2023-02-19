//
//  Movie.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 18/02/2023.
//

import Foundation

struct MoviesResponse: Decodable{
    let results: [Movie]
}

struct Movie: Decodable{
    let id: Int, title: String?, name: String?, original_title: String?, overview: String?, media_type: String?, popularity: Double?, release_date: String?, first_air_date: String? , poster_path: String?, backdrop_path: String?, vote_average: Double, vote_count: Int
}


