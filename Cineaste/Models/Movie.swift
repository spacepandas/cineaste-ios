//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright © 2017 KURZ Digital Solutions GmbH & Co. KG. All rights reserved.
//

import UIKit
import CoreData

class Movie: NSManagedObject {
    @NSManaged fileprivate(set) var id:Int64
    @NSManaged fileprivate(set) var title:String
    @NSManaged fileprivate(set) var posterPath:String
}

extension Movie:Managed {
    static var defaultSortDescriptors:[NSSortDescriptor] {
        return [NSSortDescriptor(key:#keyPath(title), ascending:false)]
    }
}
