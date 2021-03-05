//
//  StoredMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 05.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import CoreData

@available(*, deprecated, message: "Don't use Core Data")
@objc(StoredMovie)
class StoredMovie: NSManagedObject {

    convenience init(context moc: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: moc) else {
            fatalError("Unable to create entity description with \(name)")
        }

        self.init(entity: entity, insertInto: moc)
    }
}
