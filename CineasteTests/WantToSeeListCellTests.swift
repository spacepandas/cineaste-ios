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

class WantToSeeListCellTests: XCTestCase {
    let cell = WantToSeeListCell()
    
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
    
    func testConfigure() {
        cell.configure(with: storedMovie)

        XCTAssertEqual(cell.poster.image, nil)
        XCTAssertEqual(cell.title.text, storedMovie.title)
        XCTAssertEqual(cell.votes.text, "\(storedMovie.voteAverage)")
        XCTAssertEqual(cell.runtime.text, "\(storedMovie.runtime) min")
        XCTAssertEqual(cell.releaseDate.text, "\(storedMovie.releaseDate?.formatted ?? Date().formatted)")
    }

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return entity
    }()
    
}
