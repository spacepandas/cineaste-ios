//
//  SearchMoviesCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SearchMoviesCellTests: XCTestCase {
    let cell = SearchMoviesCell()
    
    override func setUp() {
        super.setUp()

        let imageView = UIImageView()
        cell.addSubview(imageView)
        cell.posterImageView = imageView

        let title = UILabel()
        cell.addSubview(title)
        cell.movieTitleLabel = title
    }
    
    func testConfigure() {
        cell.configure(with: movie)

        XCTAssertEqual(cell.movieTitleLabel.text, movie.title)
    }

    private let movie: Movie = {
        guard let path = Bundle.main.path(forResource: "Movie", ofType: "json") else {
            fatalError("Could not load file for resource Movie.json")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let movie = try! JSONDecoder().decode(Movie.self, from: data)
            return movie
        } catch let error {
            fatalError("Error while decoding Movie.json: \(error.localizedDescription)")
        }
    }()
    
}
