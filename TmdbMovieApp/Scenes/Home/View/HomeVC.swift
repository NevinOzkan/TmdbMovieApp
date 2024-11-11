//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movie: [Movie] = []
    var upcomingMovies: [Movie] = []
    let service: MovieServiceProtocol = MovieService()
    var viewModel: MovieViewModelProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            viewModel = HomeViewModel(service: service)
        }
        viewModel.delegate = self
        
        registerCells()
        
        setupUI()
    }
    
    private func registerCells() {
        let nib = UINib(nibName: "UpcomingCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpcomingCell")
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.loadUpcomingMovies(page: 1)
        viewModel.loadNowPlayingMovies()
        
        
    }
}
extension HomeVC: MovieViewModelDelegate {
    func handleViewModelOutput(_ output: MovieViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(_):
            break
        case .updateUpcomingMovies(let movieList):
            print("Upcoming Movies: \(movieList)")
            self.upcomingMovies = movieList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .updateNowPlayingMovies(_): break
           //TODO
        }
    }
    
    func navigate(to route: MovieViewRoute) {
        //TODO
    }
    
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell else {
            return UITableViewCell()
        }
        
        let movie = upcomingMovies[indexPath.row]
        cell.prepareCell(with: movie)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
