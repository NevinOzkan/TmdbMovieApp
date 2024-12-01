//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: MovieViewModelProtocol = HomeViewModel()
    var isLoading = false
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        viewModel.delegate = self
        registerCells()
        setupUI()
        setupSliderCollectionViewLayout()
        setupRefreshControl()
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
        
        viewModel.loadUpcomingMovies(page: viewModel.currentPage)
        viewModel.loadNowPlayingMovies()
        
        pageControl.numberOfPages = viewModel.nowPlayingMovies.count
        pageControl.currentPage = 0
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshData() {
        viewModel.currentPage += 1
        viewModel.upcomingMovies.removeAll()
        viewModel.nowPlayingMovies.removeAll()
        viewModel.loadUpcomingMovies(page: viewModel.currentPage)
        viewModel.loadNowPlayingMovies()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true, completion: nil)
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
                self.refreshControl.endRefreshing()
                self.isLoading = false
            }
            
        case .updateNowPlayingMovies(let movieList):
            self.viewModel.nowPlayingMovies = movieList
            DispatchQueue.main.async {
                self.sliderCollectionView.reloadData()
                self.pageControl.numberOfPages = self.viewModel.nowPlayingMovies.count
                self.pageControl.currentPage = 0
                self.refreshControl.endRefreshing()
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
        detailViewModel.load(movieID: movieID)
        
        let detailVC = DetailVC(nibName: "DetailVC", bundle: .main)
        detailVC.viewModel = detailViewModel
        detailVC.movieID = movieID
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
            if !isLoading {  
                isLoading = true
                viewModel.currentPage += 1
                viewModel.loadUpcomingMovies(page: viewModel.currentPage)
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
            fatalError("Error : NowPlayingCollectionCell")
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if pageIndex != pageControl.currentPage {
            pageControl.currentPage = pageIndex
        }
    }
}

