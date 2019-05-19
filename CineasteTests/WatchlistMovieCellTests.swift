//
//  WantToSeeListCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class WatchlistMovieCellTests: XCTestCase {
    let cell = WatchlistMovieCell()

    override func setUp() {
        super.setUp()

        let poster = UIImageView()
        cell.addSubview(poster)
        cell.poster = poster

        let separatorView = UIView()
        cell.addSubview(separatorView)
        cell.separatorView = separatorView

        let releaseAndRuntime = UILabel()
        cell.addSubview(releaseAndRuntime)
        cell.releaseAndRuntimeLabel = releaseAndRuntime

        let title = UILabel()
        cell.addSubview(title)
        cell.title = title

        let voteView = VoteView()
        cell.addSubview(voteView)
        cell.voteView = voteView
    }

    func testConfigureShouldSetCellTitleAndVotesCorrectly() {
        let movie = Movie.testing
        cell.configure(with: movie)

        XCTAssertEqual(cell.poster.image, UIImage.posterPlaceholder)
        XCTAssertEqual(cell.releaseAndRuntimeLabel.text, movie.formattedRelativeReleaseInformation
            + " ∙ "
            + movie.formattedRuntime)
        XCTAssertEqual(cell.title.text, movie.title)

        let nonbreakingSpace = "\u{00a0}"
        XCTAssertEqual(cell.voteView.content,
                       movie.formattedVoteAverage
                        + "\(nonbreakingSpace)/\(nonbreakingSpace)10")
    }
}
