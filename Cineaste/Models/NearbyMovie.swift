//
//  NearbyMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

struct NearbyMovie: Codable, Hashable {
    let id: Int64
    let posterPath: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
    }

    init (id: Int64, title: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encode(title, forKey: .title)
    }

    var hashValue: Int {
        return id.hashValue
    }

    static func == (lhs: NearbyMovie, rhs: NearbyMovie) -> Bool {
        return lhs.id == rhs.id
    }
}
