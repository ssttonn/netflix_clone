//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 18/02/2023.
//

import Foundation

class APIConstants{
    static let API_KEY = "96d9a113f757274c2eb849c5b53021aa"
    static let BASE_URL = "https://api.themoviedb.org"
}

class APICaller{
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/trending/movie/day?api_key=\(APIConstants.API_KEY)") else {return}
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {return}
            do{
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/trending/tv/day?api_key=\(APIConstants.API_KEY)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            do{
                guard let data = data, error == nil else {return}
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/movie/popular?api_key=\(APIConstants.API_KEY)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/movie/upcoming?api_key=\(APIConstants.API_KEY)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/movie/top_rated?api_key=\(APIConstants.API_KEY)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/discover/movie?api_key=\(APIConstants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func search(query: String, completion: @escaping (Result<[Movie], Error>)-> Void){
        guard let url = URL(string: "\(APIConstants.BASE_URL)/3/search/movie?api_key=\(APIConstants.API_KEY)&query=\(query)") else{
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
