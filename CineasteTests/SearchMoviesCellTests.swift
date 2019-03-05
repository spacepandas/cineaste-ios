//
//  SearchMoviesCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

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
        cell.detailLabel = description

        let watchedStateImageView = UIImageView()
        cell.addSubview(watchedStateImageView)
        cell.stateImageView = watchedStateImageView

        let soonReleaseView = HintView()
        cell.addSubview(soonReleaseView)
        cell.soonHint = soonReleaseView
    }

    func testConfigureShouldSetCellTitleAndDetailsCorrectly() {
        cell.configure(with: movie, state: .seen)

        XCTAssertEqual(cell.title.text, movie.title)
        XCTAssertEqual(cell.detailLabel.text, "2017 ∙ 6.9 / 10")
        XCTAssert(cell.soonHint.isHidden)
    }

    func testConfigureShouldSetStateImageForSeen() {
        cell.configure(with: movie, state: .seen)
        XCTAssertEqual(cell.stateImageView.image, #imageLiteral(resourceName: "seen-badge"))
        XCTAssertFalse(cell.stateImageView.isHidden)
    }

    func testConfigureShouldSetStateImageForWatchlist() {
        cell.configure(with: movie, state: .watchlist)
        XCTAssertEqual(cell.stateImageView.image, #imageLiteral(resourceName: "watchlist-badge"))
        XCTAssertFalse(cell.stateImageView.isHidden)
    }

    func testConfigureShouldSetStateImageForNormal() {
        cell.configure(with: movie, state: .undefined)
        XCTAssertTrue(cell.stateImageView.isHidden)
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
