//
//  TmdbMovieAppTests.swift
//  TmdbMovieAppTests
//
//  Created by Nevin Özkan on 11.11.2024.
//

import XCTest
@testable import TmdbMovieApp

final class TmdbMovieAppTests: XCTestCase {


    func testParsing() throws {
        
        let bundle = Bundle(for: TmdbMovieAppTests.self)
              guard let url = bundle.url(forResource: "movie", withExtension: "json") else { return }
              let data = try Data(contentsOf: url)
              let decoder = Decoders.releaseDateDecoder
              let movie = try decoder.decode(Movie.self, from: data)
       
              XCTAssertEqual(movie.id, 1034541)
              XCTAssertEqual(movie.overview, "Five years after surviving Art the Clown's Halloween massacre, Sienna and Jonathan are still struggling to rebuild their shattered lives. As the holiday season approaches, they try to embrace the Christmas spirit and leave the horrors of the past behind. But just when they think they're safe, Art returns, determined to turn their holiday cheer into a new nightmare. The festive season quickly unravels as Art unleashes his twisted brand of terror, proving that no holiday is safe.")
              XCTAssertEqual(movie.title, "Terrifier 3")
              XCTAssertEqual(movie.posterPath, "/63xYQj1BwRFielxsBDXvHIJyXVm.jpg")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
