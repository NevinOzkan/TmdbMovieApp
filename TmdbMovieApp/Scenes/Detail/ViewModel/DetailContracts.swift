//
//  DetailContracts.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

// ViewModel'in protokolü
protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set } // Delegate referansı
    var movie: Movie? { get set } // Film verisini tutacak değişken
    func load(movieID: Int) // Film detaylarını yüklemek için fonksiyon
}

// Delegate protokolü (ViewController tarafından benimsenir)
protocol DetailViewModelDelegate: AnyObject {
    func fetchMovieDetails(_ movie: Movie) // ViewModel'den gelen veriyi alacak fonksiyon
}
