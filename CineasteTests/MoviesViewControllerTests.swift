//
//  MoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
import CoreData
@testable import Cineaste

class MoviesViewControllerTests: XCTestCase {
    let moviesVC = MoviesViewController.instantiate()
    var tableView: UITableView!

    override func setUp() {
        super.setUp()
        tableView = moviesVC.myMoviesTableView
        tableView.dataSource = moviesVC
    }

    func testFetchedResultsManagerDelegateIsNotNil() {
        moviesVC.viewDidLoad()
        XCTAssertNotNil(moviesVC.fetchedResultsManager.delegate)
    }

    func testPrepareForSegueShouldInjectCorrectContentToSearchVC() {
        let naviTargetViewController = SearchMoviesViewController.instantiateInNavigationController()
        let targetViewController = naviTargetViewController.viewControllers.first as! SearchMoviesViewController
        let targetSegue = UIStoryboardSegue(
            identifier: Segue.showSearchFromMovieList.rawValue,
            source: moviesVC,
            destination: naviTargetViewController)

        XCTAssertNil(targetViewController.storageManager)

        //inject storageManager
        moviesVC.prepare(for: targetSegue, sender: moviesVC)

        XCTAssertNotNil(targetViewController.storageManager)
    }

    func testPrepareForSegueShouldInjectCorrectContentToMovieDetailVC() {
        let targetViewController = MovieDetailViewController.instantiate()
        let targetSegue = UIStoryboardSegue(
            identifier: Segue.showMovieDetail.rawValue,
            source: moviesVC,
            destination: targetViewController)

        XCTAssertNil(targetViewController.storedMovie)
        XCTAssertNil(targetViewController.storageManager)

        //inject selectedMovie
        moviesVC.selectedMovie = storedMovie
        moviesVC.prepare(for: targetSegue, sender: moviesVC)

        XCTAssertEqual(targetViewController.storedMovie, storedMovie)
        XCTAssertNotNil(targetViewController.storageManager)
    }

    func testSettingCategoryShouldChangeTitleOfVC() {
        let seenTitle = MovieListCategory.seen.title
        moviesVC.category = .seen
        XCTAssertEqual(moviesVC.title, seenTitle)

        let wantToSeeTitle = MovieListCategory.wantToSee.title
        moviesVC.category = .wantToSee
        XCTAssertEqual(moviesVC.title, wantToSeeTitle)
    }

    func testEmptyListShouldHideTableView() {
        if moviesVC.fetchedResultsManager.controller?.fetchedObjects?.isEmpty ?? true {
            XCTAssertTrue(moviesVC.myMoviesTableView.isHidden)
        } else {
            XCTAssertFalse(moviesVC.myMoviesTableView.isHidden)
        }
    }

    func testNumberOfRowsShouldEqualNumberOfFetchedObjects() {
        if moviesVC.fetchedResultsManager.controller?.fetchedObjects?.isEmpty ?? true {
            XCTAssertEqual(moviesVC.myMoviesTableView.numberOfRows(inSection: 0), 0)
        } else {
            XCTAssertEqual(moviesVC.myMoviesTableView.numberOfRows(inSection: 0), moviesVC.fetchedResultsManager.controller?.fetchedObjects?.count)
        }
    }

    private let storedMovie: StoredMovie = {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "StoredMovie", into: managedObjectContext) as! StoredMovie
        return entity
    }()
}
