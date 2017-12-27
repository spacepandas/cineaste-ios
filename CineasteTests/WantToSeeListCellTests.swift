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

        let title = UILabel()
        cell.addSubview(title)
        cell.title = title

        let votes = UILabel()
        cell.addSubview(votes)
        cell.votes = votes
    }
    
    func testConfigure() {
        cell.configure(with: storedMovie)

        XCTAssertEqual(cell.title.text, storedMovie.title)
        XCTAssertEqual(cell.votes.text, "Votes: \(storedMovie.voteAverage)")
    }

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return entity
    }()
    
}
