//
//  DetailMovie.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 1.12.2024.
//

import Foundation

public struct DetailMovie: Decodable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String?
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let imdbID: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case imdbID = "imdb_id"
    }
}
