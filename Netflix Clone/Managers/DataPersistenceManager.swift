//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 24/02/2023.
//

import Foundation
import UIKit

class DataPersistenceManager{
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(model: Movie,completion: @escaping (Result<Void, Error>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let context = appDelegate.persitentContainer.viewContext
        let item = MovieItem(context: context)
        item.title = model.title ?? model.original_title ?? model.name
        item.poster_path = model.poster_path
    }
    
    func fetchDownloadedMovies(){
        
    }
}
