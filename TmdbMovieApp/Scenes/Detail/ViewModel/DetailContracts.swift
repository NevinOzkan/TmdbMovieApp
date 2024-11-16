//
//  DetailContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func load(movieId: Int)
}

protocol DetailViewModelDelegate: AnyObject {
        func showMovieDetails(_ movie: Movie)
}
