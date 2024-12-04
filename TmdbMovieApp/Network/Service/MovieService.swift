//
//  MovieService.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation
import Alamofire

public protocol MovieServiceProtocol {
    
    func fetchNowPlayingMovies(completion: @escaping (Result<MoviesModelResponse>) -> Void)
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<MoviesModelResponse>) -> Void)
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieModel>) -> Void)
}

public class MovieService: MovieServiceProtocol {

    public var nowPlayingMovies: [MovieModel] = []
    public var upcomingMovies: [MovieModel] = []
    var currentPage: Int = 1
    
    public enum Error: Swift.Error {
        case serializationError(internal: Swift.Error)
        case networkError(internal: Swift.Error)
    }
  
    public func fetchNowPlayingMovies(completion: @escaping (Result<MoviesModelResponse>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=1ae0a7f53c245e3bc03196612d1e663a&language=en-US&region=US&page=\(currentPage)"
        
        AF.request(urlString).responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = Decoders.releaseDateDecoder
                do {
                    let response = try decoder.decode(MoviesModelResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(Error.serializationError(internal: error)))
                }
            case .failure(let error):
                completion(.failure(Error.networkError(internal: error)))
            }
        }
    }
    
    public func fetchUpcomingMovies(page: Int, completion: @escaping (Result<MoviesModelResponse>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=1ae0a7f53c245e3bc03196612d1e663a&language=en-US&region=US&page=\(page)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = Decoders.releaseDateDecoder
                do {
                    let response = try decoder.decode(MoviesModelResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(Error.serializationError(internal: error)))
                }
            case .failure(let error):
                completion(.failure(Error.networkError(internal: error)))
            }
        }
    }
    
    public func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieModel>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=1ae0a7f53c245e3bc03196612d1e663a&language=en-US"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let movie = try JSONDecoder().decode(MovieModel.self, from: data)
                    completion(.success(movie))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
