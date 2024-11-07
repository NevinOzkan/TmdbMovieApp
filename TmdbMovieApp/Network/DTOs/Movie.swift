//
//  Movie.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 5.11.2024.
//

import Foundation

public struct Movie: Decodable, Equatable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let imdbID: String?

    private enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case imdbID = "imdb_id"
    }

// Implementing Equatable to compare Movie objects
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.adult == rhs.adult &&
            lhs.backdropPath == rhs.backdropPath &&
            lhs.genreIds == rhs.genreIds &&
            lhs.id == rhs.id &&
            lhs.originalLanguage == rhs.originalLanguage &&
            lhs.originalTitle == rhs.originalTitle &&
            lhs.overview == rhs.overview &&
            lhs.popularity == rhs.popularity &&
            lhs.posterPath == rhs.posterPath &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.title == rhs.title &&
            lhs.video == rhs.video &&
            lhs.voteAverage == rhs.voteAverage &&
            lhs.voteCount == rhs.voteCount &&
            lhs.imdbID == rhs.imdbID
    }
}
