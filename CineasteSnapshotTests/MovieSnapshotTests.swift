//
//  MovieSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 28.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class MovieSnapshotTests: XCTestCase {

    func testCURLForSearch() throws {
        // Given
        let resource = Movie.search(withQuery: "", page: 0)

        // When
        let request = try XCTUnwrap(resource.request)

        // Then
        assertSnapshot(matching: request, as: .curl)
    }

    func testCURLForLatestReleases() throws {
        // Given
        let resource = Movie.latestReleases(page: 0)

        // When
        let request = try XCTUnwrap(resource.request)

        // Then
        assertSnapshot(matching: request, as: .curl)
    }

    func testCURLForDetails() throws {
        // Given
        let resource = Movie.testing.get

        // When
        let request = try XCTUnwrap(resource.request)

        // Then
        assertSnapshot(matching: request, as: .curl)
    }

}

private extension Resource {

    /// This creates an URLRequest for a resource, so it can be snapshotted
    var request: URLRequest? {
        let urlString = url.securedAPIKey
        guard let url = URL(string: urlString) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

private extension String {

    /// This secures the api key and uses "xxx" for that
    var securedAPIKey: String {
        var queries = split(separator: "&")

        let index = queries.firstIndex { $0.starts(with: "api_key") }
        // swiftlint:disable:next force_unwrapping
        queries[index!] = "api_key=xxx"

        return queries.joined(separator: "&")
    }
}
