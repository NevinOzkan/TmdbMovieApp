//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit

class HomeVC: UIViewController {

    let service: MovieServiceProtocol = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchUpcomingMovies { (result) in
            print(result)
        }
        service.fetchNowPlayingMovies { (result) in
            print(result)
        }
        
    }

}
