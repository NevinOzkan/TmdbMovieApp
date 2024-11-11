//
//  DetailContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func load()
}

//film detaylarının gösterimiyle ilgili geri bildirimleri işlemek için.
protocol DetailViewModelDelegate: AnyObject {
    func showUpcomingMovies(_ movie: Movie)
}
