//
//  WantToSeeListCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste

class MovieListCellTests: XCTestCase {
    let cell = MovieListCell()
    
    override func setUp() {
        super.setUp()

        let poster = UIImageView()
        cell.addSubview(poster)
        cell.poster = poster

        let title = TitleLabel()
        cell.addSubview(title)
        cell.title = title

        let separatorView = UIView()
        cell.addSubview(separatorView)
        cell.separatorView = separatorView

        let votes = DescriptionLabel()
        cell.addSubview(votes)
        cell.votes = votes

        let runtime = DescriptionLabel()
        cell.addSubview(runtime)
        cell.runtime = runtime

        let releaseDate = DescriptionLabel()
        cell.addSubview(releaseDate)
        cell.releaseDate = releaseDate
    }
    
    func testConfigureShouldSetCellTitleAndVotesCorrectly() {
        cell.configure(with: storedMovie)

        XCTAssertEqual(cell.poster.image, UIImage.posterPlaceholder)
        XCTAssertEqual(cell.title.text, storedMovie.title)
        XCTAssertEqual(cell.votes.text, storedMovie.formattedVoteAverage)
        XCTAssertEqual(cell.runtime.text, storedMovie.formattedRuntime)
        XCTAssertEqual(cell.releaseDate.text, storedMovie.formattedReleaseDate)
    }

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return entity
    }()
    
}
