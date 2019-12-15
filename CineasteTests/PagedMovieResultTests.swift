//
//  PagedMovieResultTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 25.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class PagedMovieResultTests: XCTestCase {

    func testDecodingFromNetwork() throws {
        // Given
        let expectedPagedMovieResult = PagedMovieResult.testing

        let jsonData = """
            {
              "page": 1,
              "total_results": 1,
              "total_pages": 1,
              "results": [
                {
                  "popularity": 7.582,
                  "vote_count": 499,
                  "poster_path": "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
                  "id": 515042,
                  "title": "Free Solo",
                  "vote_average": 8,
                  "runtime": 100,
                  "overview": "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
                  "release_date": "2018-10-12",
                  "genres": [
                    {
                      "id": 99,
                      "name": "Documentary"
                    }
                  ]
                }
              ]
            }
            """
            .data(using: .utf8)!

        // When
        let pagedMovieResult = try JSONDecoder().decode(
            PagedMovieResult.self,
            from: jsonData
        )

        // Then
        XCTAssertEqual(pagedMovieResult, expectedPagedMovieResult)
    }
}
