//
//  ReleaseDatesTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 09.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App_Dev

class ReleaseDatesTests: XCTestCase {

    func testTaxReligionJsonShouldResultInTaxReligionsStructWhenParsedCorrectly() {
        guard let path = Bundle(for: ReleaseDatesTests.self)
            .path(forResource: "ReleaseDates", ofType: "json") else {
                fatalError("Could not load file for resource ReleaseDates.json")
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let releaseDates = try decoder.decode(LocalizedReleaseDates.self, from: data)
            XCTAssertNotNil(releaseDates)

            let releaseDateLocale = releaseDates
                .releaseDates
                .first(where: { $0.identifier == "DE" })?
                .releaseDate
            XCTAssertNotNil(releaseDateLocale)
            XCTAssertEqual(releaseDateLocale,
                           "2018-07-13T00:00:00.000Z".dateFromISO8601)
        } catch {
            XCTFail("json could not be parsed in LocalizedReleaseDates: \(error)")
        }
    }
}
