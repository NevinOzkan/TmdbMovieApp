//
//  MoviesResponse.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 18.11.2024.
//

import Foundation

public struct MoviesModelResponse: Decodable {
    public let dates: Dates?
    public let page: Int?
    public let results: [MovieModel]
    public let totalPages:Int?
    
    
    public init(dates: Dates? = nil, page: Int? = 1, results: [MovieModel]) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = results.count
    }

    private enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
    }
}

public struct Dates: Decodable {
    public let maximum: String
    public let minimum: String

}
