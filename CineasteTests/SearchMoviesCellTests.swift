//
//  SearchMoviesCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App_Dev

class SearchMoviesCellTests: XCTestCase {
    let cell = SearchMoviesCell()
    
    override func setUp() {
        super.setUp()

        let imageView = UIImageView()
        cell.addSubview(imageView)
        cell.poster = imageView

        let title = TitleLabel()
        cell.addSubview(title)
        cell.title = title

        let view = UIView()
        cell.addSubview(view)
        cell.separatorView = view

        let description = DescriptionLabel()
        cell.addSubview(description)
        cell.releaseDate = description

        let seen = ActionButton()
        cell.addSubview(seen)
        cell.seenButton = seen

        let mustSee = ActionButton()
        cell.addSubview(mustSee)
        cell.mustSeeButton = mustSee
    }
    
    func testConfigureShouldSetCellTitleAndReleaseDateCorrectly() {
        cell.configure(with: movie)

        XCTAssertEqual(cell.title.text, movie.title)
        XCTAssertEqual(cell.releaseDate.text, movie.formattedReleaseDate)
    }

    private let movie: Movie = {
        guard let path = Bundle(for: SearchMoviesCellTests.self).path(forResource: "Movie", ofType: "json") else {
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
