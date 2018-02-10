//
//  MovieStorageManagerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 28.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste

class MovieStorageTests: XCTestCase {
    var sut: MovieStorage!

    override func setUp() {
        super.setUp()
        initStubs() // Create stubs
        sut = MovieStorage(container: mockPersistantContainer)
    }

    override func tearDown() {
        flushData() // Clear all stubs
        super.tearDown()
    }

    func testCreateStoredMovie() {
        let expc = expectation(description: "StoredMovie should be created")
        let id: Int64 = 100
        sut.insertMovieItem(id: id, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: false) { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }
        wait(for: [expc], timeout: 1)

        let storedMovies = sut.fetchAll()
        let storedMovie = storedMovies.first(where: { $0.id == id })
        XCTAssertNotNil(storedMovie)
        XCTAssertEqual(storedMovie?.id, id)
    }

    func testCreateStoredMovieWithMovie() {
        let expc = expectation(description: "StoredMovie should be created from movie")
        sut.insertMovieItem(with: movie, watched: true) { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }
        wait(for: [expc], timeout: 1.0)
        let storedMovies = sut.fetchAll()
        let storedMovie = storedMovies.first(where: { $0.id == movie.id })
        XCTAssertNotNil(storedMovie)
        XCTAssertEqual(storedMovie?.id, movie.id)

    }

    func testUpdateStoredMovie() {
        let expc = expectation(description: "Update status of movie should be set")
        let newWatchedValue = false

        let movies = sut.fetchAll()
        let movie = movies.first!
        XCTAssertEqual(movie.watched, true)

        sut.updateMovieItem(with: movie, watched: newWatchedValue) { result in
            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }
        wait(for: [expc], timeout: 1.0)

        let updatedMovies = sut.fetchAll()
        let updatedMovie = updatedMovies.first!

        XCTAssertEqual(updatedMovie.watched, newWatchedValue)
    }

    func testFetchAllMovies() {
        let results = sut.fetchAll()
        XCTAssertEqual(results.count, 4)
    }

    func testRemoveMovie() {
        let expc = expectation(description: "Movie should be removed")
        let movies = sut.fetchAll()
        let movie = movies.first!

        let numberOfMovies = movies.count

        sut.remove(movie) { result in

            switch result {
            case .success:
                expc.fulfill()
            case .error:
                break
            }
        }

        wait(for: [expc], timeout: 1.0)
        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfMovies - 1)
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

    //Convenient method for getting the number of data in store now
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StoredMovie")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }

    func initStubs() {
        func insertMovieItem(id: Int64, overview: String, poster: Data?, posterPath: String, releaseDate: Date, runtime: Int16, title: String, voteAverage: Float, watched: Bool) {
            let object = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: mockPersistantContainer.viewContext)
            object.setValue(id, forKey: "id")
            object.setValue(overview, forKey: "overview")
            object.setValue(poster, forKey: "poster")
            object.setValue(posterPath, forKey: "posterPath")
            object.setValue(releaseDate, forKey: "releaseDate")
            object.setValue(runtime, forKey: "runtime")
            object.setValue(title, forKey: "title")
            object.setValue(voteAverage, forKey: "voteAverage")
            object.setValue(watched, forKey: "watched")
        }

        //add 4 movies
        insertMovieItem(id: 1, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true)
        insertMovieItem(id: 2, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true)
        insertMovieItem(id: 3, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true)
        insertMovieItem(id: 4, overview: "", poster: nil, posterPath: "", releaseDate: Date(), runtime: 1, title: "", voteAverage: 2, watched: true)

        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        }
    }

    func flushData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredMovie")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }

    var mockPersistantContainer: NSPersistentContainer = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let container = NSPersistentContainer(name: "PersistentStoredMovies", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            // Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)

            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
}
