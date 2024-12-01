//
//  MockMoviesService.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

final class MockMoviesService: MovieServiceProtocol {

    var movies: [HomeMovie] = []
    
    func fetchNowPlayingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse))
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<DetailMovie>) -> Void) {
//        if let movie = movies.first(where: { $0.id == movieId }) {
//            completion(.success(movie)) 
//        } else {
//            let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
//            completion(.failure(error))
//        }
    }
}
