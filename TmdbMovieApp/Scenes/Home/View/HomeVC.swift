//
//  HomeVC.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 5.11.2024.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var movieList: [Movie] = []
    var upcomingMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    let service: MovieServiceProtocol = MovieService()
    var currentPage = 1
    
    // viewModel'i burada başlatıldı
    var viewModel: MovieViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if viewModel == nil {
            viewModel = HomeViewModel(service: service)
        }
        
        registerCells()
        setupSliderCollectionViewLayout()
        
        setupUI()
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
        
        // Verileri çekmeden önce dizileri boşaltın
        upcomingMovies.removeAll()
        nowPlayingMovies.removeAll()
        
        viewModel.loadUpcomingMovies(page: 1)
        viewModel.loadNowPlayingMovies()
        
        pageControl.numberOfPages = nowPlayingMovies.count
        pageControl.currentPage = 0
        
        // pageControl görünürlüğünü ve konumlandırması
        pageControl.isHidden = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: sliderCollectionView.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: -30)
        ])
    }
}

extension HomeVC: MovieViewModelDelegate {
        func handleViewModelOutput(_ output: MovieViewModelOutput) {
            switch output {
            case .updateTitle(let title):
                self.title = title
            case .setLoading(let isLoading):
                // Handle loading state if necessary
                break
            case .updateUpcomingMovies(let movieList):
                self.upcomingMovies = movieList
                tableView.reloadData()
            case .updateNowPlayingMovies(let movieList):
                self.nowPlayingMovies = movieList
                sliderCollectionView.reloadData()
                pageControl.numberOfPages = nowPlayingMovies.count
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


extension HomeVC: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMovie(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
        pageControl.currentPage = pageIndex
    }
}
