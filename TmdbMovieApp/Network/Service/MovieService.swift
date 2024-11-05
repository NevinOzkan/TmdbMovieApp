//
//  MovieService.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 5.11.2024.
//

import Foundation
import Alamofire

public protocol MovieServiceProtocol {
    
    func fetchNowPlayingMovies(completion: @escaping (Result<MoviesResponse>) -> Void)
    func fetchUpcomingMovies(completion: @escaping (Result<MoviesResponse>) -> Void)
}

public class MovieService: MovieServiceProtocol {
    
    public var movies: [Movie] = []
    var currentPage: Int = 1
    
    public enum Error: Swift.Error {
        case serializationError(internal: Swift.Error)
        case networkError(internal: Swift.Error)
    }
    
    public init() { }
    
    public func fetchNowPlayingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=1ae0a7f53c245e3bc03196612d1e663a&language=en-US&region=US&page=\(currentPage)"
            
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                print("Now Playing Movies Data:", String(data: data, encoding: .utf8) ?? "No data")
                
                let decoder = Decoders.releaseDateDecoder
                do {
                    let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                    completion(.success(moviesResponse))
                    
                    self.currentPage += 1
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(Error.serializationError(internal: error)))
                }
            case .failure(let error):
                print("Network error while fetching now-playing movies:", error.localizedDescription)
                completion(.failure(Error.networkError(internal: error)))
            }
        }
    }

    
    public func fetchUpcomingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=1ae0a7f53c245e3bc03196612d1e663a&language=en-US&region=US&page=\(currentPage)"
        
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                print("Upcoming Movies Data:", String(data: data, encoding: .utf8) ?? "No data")
                
                let decoder = Decoders.releaseDateDecoder
                do {
                    let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                    completion(.success(moviesResponse))
                    
                    // Sayfa değerini artır
                    self.currentPage += 1
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(Error.serializationError(internal: error)))
                }
            case .failure(let error):
                print("Network error while fetching upcoming movies:", error.localizedDescription)
                completion(.failure(Error.networkError(internal: error)))
            }
        }
    }
}
