//
//  SeenMovieCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 12.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class SeenMovieCellTests: XCTestCase {
    let cell = SeenMovieCell()

    override func setUp() {
        super.setUp()

        let backgroundView = UIView()
        cell.addSubview(backgroundView)
        cell.background = backgroundView

        let poster = UIImageView()
        cell.addSubview(poster)
        cell.poster = poster

        let title = UILabel()
        cell.addSubview(title)
        cell.title = title

        let separatorView = UIView()
        cell.addSubview(separatorView)
        cell.separatorView = separatorView

        let watchedDate = UILabel()
        cell.addSubview(watchedDate)
        cell.watchedDateLabel = watchedDate
    }

    func testConfigureShouldSetCellTitleAndVotesCorrectly() {
        let movie = Movie.testing

        cell.configure(with: movie)

        XCTAssertEqual(cell.poster.image, UIImage.posterPlaceholder)
        XCTAssertEqual(cell.title.text, movie.title)
        XCTAssertEqual(cell.watchedDateLabel.text, movie.formattedWatchedDate)
    }
}
