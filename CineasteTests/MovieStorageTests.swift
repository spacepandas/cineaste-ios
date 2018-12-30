//
//  MovieStorageManagerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste_App

class MovieStorageTests: XCTestCase {
    let helper = CoreDataHelper()
    var storageManager: MovieStorageManager!
    var mockPersistantContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        mockPersistantContainer = helper.mockPersistantContainer

        helper.initStubs()

        storageManager = MovieStorageManager(container: mockPersistantContainer)
    }

    override func tearDown() {
        helper.flushData()
        super.tearDown()
    }

    func testCreateStoredMovie() {
        let expc = expectation(description: "StoredMovie should be created")
        let id: Int64 = 100
        storageManager.insertMovieItem(id: id,
                                       overview: "",
                                       poster: nil,
                                       posterPath: "",
                                       releaseDate: Date(),
                                       runtime: 1,
                                       title: "",
                                       voteAverage: 2,
                                       voteCount: 1,
                                       watched: false)
        { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }
        wait(for: [expc], timeout: 1)

        let storedMovies = storageManager.fetchAll()
        let storedMovie = storedMovies.filter({ $0.id == id }).first
        XCTAssertNotNil(storedMovie)
        XCTAssertEqual(storedMovie?.id, id)
    }

    func testCreateStoredMovieWithMovie() {
        let expc = expectation(description: "StoredMovie should be created from movie")
        storageManager.insertMovieItem(with: movie, watched: true) { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }
        wait(for: [expc], timeout: 1.0)
        let storedMovies = storageManager.fetchAll()
        let storedMovie = storedMovies.filter({ $0.id == movie.id }).first
        XCTAssertNotNil(storedMovie)
        XCTAssertEqual(storedMovie?.id, movie.id)
    }

    func testUpdateStoredMovie() {
        let expc = expectation(description: "Update status of movie should be set")
        let newWatchedValue = false

        let movies = storageManager.fetchAll()
        let movie = movies.first!
        XCTAssertEqual(movie.watched, true)

        storageManager.updateMovieItem(with: movie.objectID, watched: newWatchedValue) { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }
        wait(for: [expc], timeout: 1.0)

        let updatedMovies = storageManager.fetchAll()
        let updatedMovie = updatedMovies.first!

        XCTAssertEqual(updatedMovie.watched, newWatchedValue)
    }

    func testFetchAllMovies() {
        let results = storageManager.fetchAll()
        XCTAssertFalse(results.isEmpty)
    }

    func testRemoveMovie() {
        let expc = expectation(description: "Movie should be removed")
        let movies = storageManager.fetchAll()
        let movie = movies.first!

        let numberOfMovies = movies.count

        storageManager.remove(movie) { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }

        wait(for: [expc], timeout: 1.0)
        XCTAssertEqual(helper.numberOfItemsInPersistentStore(), numberOfMovies-1)
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

