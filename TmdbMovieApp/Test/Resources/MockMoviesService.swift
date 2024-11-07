//
//  MockMoviesService.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 6.11.2024.
//

import Foundation

final class MockMoviesService: MovieServiceProtocol {
    
    var movies: [Movie] = []

    func fetchUpcomingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }

    func fetchNowPlayingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }

    func fetchMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }
}
