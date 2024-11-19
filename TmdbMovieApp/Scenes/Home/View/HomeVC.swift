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
    
    var movie: [Movie] = []
    var upcomingMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    let service: MovieServiceProtocol = MovieService()
    var viewModel: MovieViewModelProtocol!
    var currentPage = 1
    var isLoading = false
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if viewModel == nil {
            viewModel = HomeViewModel(service: service)
        }
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
        
        viewModel.loadUpcomingMovies(page: currentPage)
        viewModel.loadNowPlayingMovies()
        
        pageControl.numberOfPages = nowPlayingMovies.count
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
        currentPage = 1
        upcomingMovies.removeAll()
        nowPlayingMovies.removeAll()
        
        // Verilerin yeniden yüklenmesini sağlamak için viewModel'e çağrı yapıyoruz
        viewModel.loadUpcomingMovies(page: currentPage)
        viewModel.loadNowPlayingMovies()
        
        // Tabloyu ve koleksiyon görünümünü yeniden yüklüyoruz
        tableView.reloadData()
        sliderCollectionView.reloadData()
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
            self.upcomingMovies.append(contentsOf: movieList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.isLoading = false
            }

        case .updateNowPlayingMovies(let movieList):
            self.nowPlayingMovies = movieList
            DispatchQueue.main.async {
                self.sliderCollectionView.reloadData()
                self.pageControl.numberOfPages = self.nowPlayingMovies.count
                self.pageControl.currentPage = 0
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func navigate(to route: MovieViewRoute) {
               switch route {
               case .detail(let viewModel):
                   let detailVC = DetailVC(nibName: "DetailVC", bundle: Bundle.main)
                   detailVC.viewModel = viewModel
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
        guard let movieID = movie.id else {
            return
        }
        let service = MovieService()
        let detailViewModel = DetailViewModel(service: service)
        detailViewModel.load(movieID: movieID)
        
        let detailVC = DetailVC(nibName: "DetailVC", bundle: Bundle.main)
        detailVC.viewModel = detailViewModel
        detailVC.movieID = movieID
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let currentOffset = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.size.height
        
        if currentOffset + scrollViewHeight >= contentHeight - 50 {
            if !isLoading {
                isLoading = true
                currentPage += 1
                viewModel.loadUpcomingMovies(page: currentPage) 
            }
        }
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionCell", for: indexPath) as? NowPlayingCollectionCell else {
            fatalError("Error : NowPlayingCollectionCell")
        }
        
        let movie = nowPlayingMovies[indexPath.row]
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
        
        DispatchQueue.main.async {
            self.pageControl.currentPage = pageIndex
        }
    }
}

