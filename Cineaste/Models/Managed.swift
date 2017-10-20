//
//  Managed.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import Foundation
import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName:String {get}
    static var defaultSortDescriptors:[NSSortDescriptor] {get}
}

extension Managed where Self:NSManagedObject {
    static var entityName:String {return entity().name!}
}

extension Managed {
    static var defaultSortDescriptors:[NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest:NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName:entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}
