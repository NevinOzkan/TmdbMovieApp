//
//  MovieService.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation
import Alamofire

public protocol MovieServiceProtocol {
    
    func fetchNowPlayingMovies(completion: @escaping (Result<MoviesResponse>) -> Void)
    func fetchUpcomingMovies(completion: @escaping (Result<MoviesResponse>) -> Void)
}

public class MovieService: MovieServiceProtocol {
    
    public enum Error: Swift.Error {
           case serializationError(internal: Swift.Error)
           case networkError(internal: Swift.Error)
       }
       
       public init() { }
       
    
    public func fetchNowPlayingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=1ae0a7f53c245e3bc03196612d1e663a"
        
        AF.request(urlString).responseData { (response) in
                   switch response.result {
                   case .success(let data):
                       let decoder = Decoders.releaseDateDecoder
                       do {
                           let response = try decoder.decode(MoviesResponse.self, from: data)
                           completion(.success(response))
                       } catch {
                           completion(.failure(Error.serializationError(internal: error)))
                       }
                   case .failure(let error):
                       completion(.failure(Error.networkError(internal: error)))
                   }
               }
           }
       
    
    public func fetchUpcomingMovies(completion: @escaping (Result<MoviesResponse>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=1ae0a7f53c245e3bc03196612d1e663a"
        
        AF.request(urlString).responseData { (response) in
                   switch response.result {
                   case .success(let data):
                       let decoder = Decoders.releaseDateDecoder
                       do {
                           let response = try decoder.decode(MoviesResponse.self, from: data)
                           completion(.success(response))
                       } catch {
                           completion(.failure(Error.serializationError(internal: error)))
                       }
                   case .failure(let error):
                       completion(.failure(Error.networkError(internal: error)))
                   }
               }
    }
}
