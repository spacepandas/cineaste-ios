//
//  ReleaseDatesTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 09.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class ReleaseDatesTests: XCTestCase {

    func testReleaseDateJsonShouldResultInReleaseDateStructWhenParsedCorrectly() {
        guard let path = Bundle(for: ReleaseDatesTests.self)
            .path(forResource: "ReleaseDates", ofType: "json") else {
                fatalError("Could not load file for resource ReleaseDates.json")
        }

        precondition(Locale.current.identifier == "en_US",
                     """
                     Region in simulator has to be set to US to successfully \
                     use the mock data.
                     """
        )

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .alwaysMapped)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let releaseDates = try? decoder.decode(LocalizedReleaseDate.self,
                                                   from: data)
            XCTAssertNotNil(releaseDates)

            let date = releaseDates?.date
            XCTAssertNotNil(date)
            XCTAssertEqual(date, "2003-12-17T00:00:00.000Z".dateFromISO8601)
        } catch {
            XCTFail("json couldn't be parsed to LocalizedReleaseDates: \(error)")
        }
    }
}
