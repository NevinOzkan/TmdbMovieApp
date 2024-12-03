//
//  MockMoviesService.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

final class MockMoviesService: MovieServiceProtocol {

    var movies: [MovieModel] = []

    func fetchNowPlayingMovies(completion: @escaping (Result<MoviesModelResponse>) -> Void) {
        let moviesResponse = MoviesModelResponse(results: movies)
        completion(.success(moviesResponse))
    }

    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<MoviesModelResponse>) -> Void) {
        let moviesResponse = MoviesModelResponse(results: movies)
        completion(.success(moviesResponse))
    }

    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieModel>) -> Void) {
        if let movie = movies.first(where: { $0.id == movieId }) {
            let detailMovie = MovieModel(
                id: movie.id,
                title: movie.title,
                overview: movie.overview,
                backdropPath: "",
                posterPath: "",
                releaseDate: "N/A",
                voteAverage: 0.0,
                imdbID: ""
            )
            completion(.success(detailMovie))
        } else {
            let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Movie not found"])
            completion(.failure(error))
        }
    }
}
