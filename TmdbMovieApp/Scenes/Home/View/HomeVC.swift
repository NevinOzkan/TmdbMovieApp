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
    var currentPage = 1 // Sayfa numarasını takip etmek için
    var isLoading = false // Yeni veriler yüklenirken birden fazla yükleme yapılmasını engellemek için
    
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
        
        viewModel.loadUpcomingMovies(page: currentPage)
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
            self.upcomingMovies.append(contentsOf: movieList) // Yeni filmleri mevcut listeye ekleyin
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .updateNowPlayingMovies(_): break
            //TODO
        }
    }
    
    func navigate(to route: MovieViewRoute) {
               switch route {
               case .detail(let viewModel):
                   let detailVC = DetailVC(nibName: "DetailVC", bundle: Bundle.main)
                   detailVC.viewModel = viewModel // Detay ViewModel'ini bağla
                   self.navigationController?.pushViewController(detailVC, animated: true)
               }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = upcomingMovies[indexPath.row]
        let detailViewModel = DetailViewModel(movie: movie, service: service)
        
        let detailVC = DetailVC(nibName: "DetailVC", bundle: Bundle.main)
        detailVC.viewModel = detailViewModel  // Detay ViewModel'ini bağla
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Sayfanın sonuna yaklaşıldığında yeni veri yüklemeyi tetikle
       func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let contentHeight = scrollView.contentSize.height
           let currentOffset = scrollView.contentOffset.y
           let scrollViewHeight = scrollView.frame.size.height
           
           // Tablonun sonuna yaklaşınca yeni verileri yükle
           if currentOffset + scrollViewHeight >= contentHeight - 50 {
               // Yalnızca yeni veri yükleniyorsa tetiklesin
               if !isLoading {
                   isLoading = true
                   currentPage += 1
                   viewModel.loadUpcomingMovies(page: currentPage)
               }
           }
       }
    
}
