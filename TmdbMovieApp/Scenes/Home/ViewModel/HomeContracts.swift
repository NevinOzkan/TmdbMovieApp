//
//  HomeContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

protocol MovieViewModelProtocol {
    var delegate: MovieViewModelDelegate? { get set }
    var upcomingMovies: [MovieModel] { get set }
    var nowPlayingMovies: [MovieModel] { get set }
    var currentPage: Int { get set }
    var isLoading: Bool { get set }
    func loadUpcomingMovies()
    func loadNowPlayingMovies()
}

enum MovieViewModelOutput {
    case updateUpcomingMovies([MovieModel])
    case updateNowPlayingMovies([MovieModel])
}

protocol MovieViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieViewModelOutput)
    func showError(_ message: String) 
}

enum MovieViewRoute {
    case detail(viewModel: DetailViewModelProtocol)
}
