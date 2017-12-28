//
//  SeenListCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste

class SeenListCellTests: XCTestCase {
    let cell = SeenListCell()

    override func setUp() {
        super.setUp()

        let title = UILabel()
        cell.addSubview(title)
        cell.title = title
    }

    func testConfigure() {
        cell.configure(with: storedMovie)

        XCTAssertEqual(cell.title.text, storedMovie.title)
    }

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return entity
    }()

}
