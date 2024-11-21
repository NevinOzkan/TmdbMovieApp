//
//  DetailContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

// ViewModel'in protokolü
protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func load(movieID: Int)
}

protocol DetailViewModelDelegate: AnyObject {
    func fetchMovieDetails(_ movie: Movie)
}
