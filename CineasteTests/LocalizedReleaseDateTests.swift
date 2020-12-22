//
//  LocalizedReleaseDateTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class LocalizedReleaseDateTests: XCTestCase {

    func testDecoding() throws {
        // Given
        XCTAssertEqual(Locale.current.regionCode, "US")

        // 1974-11-14
        let expectedDate = Date(timeIntervalSince1970: 153_619_200)

        let jsonData = """
            {
              "release_dates": {
                "results": [
                  {
                    "iso_3166_1": "DE",
                    "release_dates": [
                      {
                        "certification": "0",
                        "iso_639_1": "",
                        "note": "",
                        "release_date": "1974-11-15T00:00:00.000Z",
                        "type": 3
                      }
                    ]
                  },
                  {
                    "iso_3166_1": "NL",
                    "release_dates": [
                      {
                        "certification": "",
                        "iso_639_1": "",
                        "note": "Nederland 1",
                        "release_date": "2004-10-17T00:00:00.000Z",
                        "type": 6
                      }
                    ]
                  },
                  {
                    "iso_3166_1": "US",
                    "release_dates": [
                      {
                        "certification": "",
                        "iso_639_1": "",
                        "note": "",
                        "release_date": "1974-11-14T00:00:00.000Z",
                        "type": 3
                      }
                    ]
                  }
                ]
              }
            }
            """
            .data(using: .utf8)!

        // When
        let releaseDate = try JSONDecoder().decode(
            LocalizedReleaseDate.self,
            from: jsonData
        ).date

        // - region identifier (iso_3166_1) has to be the current region
        // - type has to be 3 (= Theatrical)
        // - region identifier (iso_639_1) has to be empty (means, equal to the
        // iso_3166_1 identifier) or equal the current region

        // Then
        XCTAssertEqual(releaseDate, expectedDate)
    }

}
