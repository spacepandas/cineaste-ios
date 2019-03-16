//
//  SeenMovieCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 12.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App

class SeenMovieCellTests: XCTestCase {
    let cell = SeenMovieCell()

    override func setUp() {
        super.setUp()

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
        cell.configure(with: storedMovie)

        XCTAssertEqual(cell.poster.image, UIImage.posterPlaceholder)
        XCTAssertEqual(cell.title.text, storedMovie.title)
        XCTAssertEqual(cell.watchedDateLabel.text, storedMovie.formattedWatchedDate)
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
