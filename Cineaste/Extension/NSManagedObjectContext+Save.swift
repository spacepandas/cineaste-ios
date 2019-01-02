//
//  NSManagedObjectContext+Save.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 29.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func saveOrRollback(completion: ((_ result: Result<Bool>) -> Void)? = nil) {
        guard hasChanges else {
            print("💡 No need to save context without changes")
            completion?(Result.success(true))
            return
        }

        do {
            try save()
            completion?(Result.success(true))
        } catch {
            rollback()
            completion?(Result.error(error))
        }
    }

    func performChanges(block: @escaping () -> Void) {
        perform {
            block()
            self.saveOrRollback()
        }
    }
}
