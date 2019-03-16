//
//  WantToSeeListCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
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

        let voteView = UIView()
        cell.addSubview(voteView)
        cell.voteView = voteView

        let category = UILabel()
        cell.addSubview(category)
        cell.categoryLabel = category
    }

    func testConfigureShouldSetCellTitleAndVotesCorrectly() {
        cell.configure(with: storedMovie)

        XCTAssertEqual(cell.poster.image, UIImage.posterPlaceholder)
        XCTAssertEqual(cell.releaseAndRuntimeLabel.text, storedMovie.formattedRelativeReleaseInformation
            + " ∙ "
            + storedMovie.formattedRuntime)
        XCTAssertEqual(cell.title.text, storedMovie.title)
    }

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription
            .insertNewObject(forEntityName: "StoredMovie",
                             into: managedObjectContext)
            as! StoredMovie
        return entity
    }()

}
