//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: MovieViewModelProtocol = HomeViewModel()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        viewModel.delegate = self
        registerCells()
        setupUI()
        setupSliderCollectionViewLayout()
    }
    
    private func registerCells() {
        let nib = UINib(nibName: "UpcomingCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpcomingCell")
        
        let collectionNib = UINib(nibName: "NowPlayingCollectionCell", bundle: nil)
        sliderCollectionView.register(collectionNib, forCellWithReuseIdentifier: "NowPlayingCollectionCell")
    }
    
    private func setupSliderCollectionViewLayout() {
        if let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            sliderCollectionView.isPagingEnabled = true
        }
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        viewModel.loadUpcomingMovies()
        viewModel.loadNowPlayingMovies()
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: -10)
        ])
    }
    
}

extension HomeVC: MovieViewModelDelegate {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func handleViewModelOutput(_ output: MovieViewModelOutput) {
        switch output {
        case .updateUpcomingMovies(let movieList):
            self.viewModel.upcomingMovies = movieList
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.viewModel.isLoading = false
            }
            
        case .updateNowPlayingMovies(let movieList):
            self.viewModel.nowPlayingMovies = movieList
            DispatchQueue.main.async {
                self.sliderCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.nowPlayingMovies.count
                self.pageControl.currentPage = 0
                
            }
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell else {
            return UITableViewCell()
        }
        let movie = viewModel.upcomingMovies[indexPath.row]
        cell.prepareCell(with: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieID = viewModel.upcomingMovies[indexPath.row].id
        navigateToDetail(with: movieID)
    }
    
    private func navigateToDetail(with movieID: Int) {
        let detailViewModel = DetailViewModel()
        
        let detailVC = DetailVC()
        detailVC.viewModel = detailViewModel
        detailVC.movieID = movieID
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let frameHeight = scrollView.frame.size.height
            
            
            if offsetY > contentHeight - frameHeight - 100 && !viewModel.isLoading {
                print("***** ", viewModel.isLoading)
                if viewModel.currentPage <= viewModel.totalPages {
                    viewModel.loadUpcomingMovies()
                }
            }
        }
    }
}


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionCell", for: indexPath) as? NowPlayingCollectionCell else {
            fatalError("Error: NowPlayingCollectionCell")
        }
        
        let movie = viewModel.nowPlayingMovies[indexPath.row]
        cell.prepareCell(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.nowPlayingMovies[indexPath.row]
        let detailVC = DetailVC()
        
        detailVC.movieID = selectedMovie.id
        let viewModel = DetailViewModel()
        detailVC.viewModel = viewModel
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == sliderCollectionView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            if pageIndex != pageControl.currentPage {
                pageControl.currentPage = pageIndex
            }
        }
    }
}
