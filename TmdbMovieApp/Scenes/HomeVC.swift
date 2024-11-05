//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 5.11.2024.
//

import UIKit

class HomeVC: UIViewController {

    let service : MovieServiceProtocol = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchNowPlayingMovies { (result) in
            print(result)
        }
        service.fetchUpcomingMovies { (result) in
            print(result)
        }
    }
}
