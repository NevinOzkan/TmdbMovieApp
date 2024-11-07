//
//  TmdbMovieAppTests.swift
//  TmdbMovieAppTests
//
//  Created by Nevin Özkan on 5.11.2024.
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
            // Given:
            let movie1 = try ResourceLoader.loadMovie(resource: .movie1)
            let movie2 = try ResourceLoader.loadMovie(resource: .movie2)
            service.movies = [movie1, movie2]
            
            // When:
            viewModel.loadUpcomingMovies()
            
            // Then:
            print("Çıktılar:", view.outputs) // Burada diziyi kontrol et
            XCTAssertEqual(view.outputs.count, 3) // 3 eleman bekleniyor
            
            // SetLoading(true) bekleniyor
            XCTAssertEqual(view.outputs[0], .setLoading(true))
            
            // SetLoading(false) bekleniyor
            XCTAssertEqual(view.outputs[1], .setLoading(false))
            
            let expectedMovies = [movie1, movie2]
            
            // Movielist bekleniyor
            XCTAssertEqual(view.outputs[2], .movielist(expectedMovies))
        }





    // Mock View: ViewModel'in çıktıları ile etkileşimde bulunan sınıf
    private class MockView: MovieViewModelDelegate {
        func navigate(to route: TmdbMovieApp.MovieViewRoute) {
            //TODO
        }
        
    
   var outputs: [MovieViewModelOutput] = []
        
        func handleViewModelOutput(_ output: MovieViewModelOutput) {
            outputs.append(output)
        }
    }

    
    func testExample() throws {
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
