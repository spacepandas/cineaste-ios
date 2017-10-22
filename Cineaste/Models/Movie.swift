//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class Movie: Codable {
    fileprivate(set) var id:Int64
    fileprivate(set) var title:String
//    @NSManaged fileprivate(set) var posterPath:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError("encode not implemented on \(Movie.self)")
    }
}

//extension Movie:Managed {
//    static var defaultSortDescriptors:[NSSortDescriptor] {
//        return [NSSortDescriptor(key:#keyPath(title), ascending:false)]
//    }
//}

