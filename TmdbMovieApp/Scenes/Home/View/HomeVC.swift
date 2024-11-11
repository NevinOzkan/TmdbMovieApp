//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
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


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
