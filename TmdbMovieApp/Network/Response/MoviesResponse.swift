//
//  MoviesResponse.swift
//  TmdbMovieApp
//
//  Created by Nevin Özkan on 18.11.2024.
//

import Foundation

public struct MoviesResponse: Decodable {
    public let dates: Dates?
    public let page: Int?
    public let results: [Movie]
    
    // `init` metodu, varsayılan değerlerle manuel oluşturulabilir.
    public init(dates: Dates? = nil, page: Int? = 1, results: [Movie]) {
        self.dates = dates
        self.page = page
        self.results = results
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
    
    // Varsayılan bir `init` metodu
    public init(maximum: String, minimum: String) {
        self.maximum = maximum
        self.minimum = minimum
    }
}
