//
//  HomeContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 6.11.2024.
//

import Foundation

//  View, bu protokolü benimseyen bir ViewModel ile etkileşimde bulunur.
protocol MovieViewModelProtocol {
    var delegate: MovieViewModelDelegate? { get set }
    func loadUpcomingMovies()
    func loadNowPlayingMovies()
    func selectMovie(at index: Int)
}

//ViewModel’in View’a göndereceği çıktıları tanımlar
enum MovieViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case movielist([Movie])
}

// ViewModel ile  View  arasındaki iletişimi tanımlar.
protocol MovieViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: MovieViewModelOutput)
    func navigate(to route: MovieViewRoute)
}

// view modelin hangi yönlendirmeleri yapması gerektiğini belirtir.
enum MovieViewRoute {
   //
}

