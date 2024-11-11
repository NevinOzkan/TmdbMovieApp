//
//  MoviesResponse.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 11.11.2024.
//

import Foundation

public struct MoviesResponse: Decodable {
    public let dates: Dates
    public let page: Int
    public let results: [Movie]
    
    public init(results: [Movie]) {
        self.results = results
        self.dates = Dates(maximum: "", minimum: "")
        self.page = 1
    }

    private enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
    }
}

public struct Dates: Decodable {
    public let maximum: String
    public let minimum: String
}
