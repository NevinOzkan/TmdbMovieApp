//
//  HomeContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

protocol MovieViewModelProtocol {
    var delegate: MovieViewModelDelegate? { get set }
    func loadUpcomingMovies(page: Int)
    func loadNowPlayingMovies()
}

//ViewModel’in View’a göndereceği çıktıları tanımlar
enum MovieViewModelOutput: Equatable {
    case updateTitle(String)
    case setLoading(Bool)
    case updateUpcomingMovies([Movie])
    case updateNowPlayingMovies([Movie])
   
}

// ViewModel ile  View  arasındaki iletişimi tanımlar.
protocol MovieViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieViewModelOutput)
    func navigate(to route: MovieViewRoute)
}

// view modelin hangi yönlendirmeleri yapması gerektiğini belirtir.
enum MovieViewRoute {
    case detail(viewModel: DetailViewModelProtocol)
}
