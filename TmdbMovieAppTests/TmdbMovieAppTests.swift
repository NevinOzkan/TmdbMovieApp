//
//  TmdbMovieAppTests.swift
//  TmdbMovieAppTests
//
//  Created by Nevin Özkan on 11.11.2024.
//

import XCTest
@testable import TmdbMovieApp

final class TmdbMovieAppTests: XCTestCase {
    
        private var view: MockView!
        private var viewModel: HomeViewModel!
        private var service: MockMoviesService!
        
        override func setUpWithError() throws {
            service = MockMoviesService()
            viewModel = HomeViewModel(service: service)
            view = MockView()
            viewModel.delegate = view
        }

  
    func testLoad() throws {
        func testLoad() throws {
            // Given:
            let movie1 = try ResourceLoader.loadMovie(resource: .movie1)
            let movie2 = try ResourceLoader.loadMovie(resource: .movie2)
            service.movies = [movie1, movie2]
            
            // When:
            viewModel.loadUpcomingMovies(page: 0)
            
            // Then:
            XCTAssertEqual(view.outputs.count, 4)
            
            // Çıktıları adım adım kontrol edelim
            for (index, output) in view.outputs.enumerated() {
                print("Output \(index): \(output)")
            }
        }
    }

    private class MockView: MovieViewModelDelegate {
        func navigate(to route: TmdbMovieApp.MovieViewRoute) {
            //TODO
        }
        
        
        var outputs: [MovieViewModelOutput] = []
        
        func handleViewModelUpcomingOutput(_ output: TmdbMovieApp.MovieViewModelOutput) {
            outputs.append(output)
        }
        
        func handleViewModelNowPlayingOutput(_ output: TmdbMovieApp.MovieViewModelOutput) {
            outputs.append(output)
        }
    }
    
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


}
