//
//  NSManagedObjectContext+Save.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 29.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func saveOrRollback() {
        do {
            try save()
        } catch {
            rollback()
        }
    }

    func performChanges(block: @escaping () -> Void) {
        perform {
            block()
            self.saveOrRollback()
        }
    }
}
