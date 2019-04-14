//
//  SortDescriptor.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 14.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

// credits: http://chris.eidhof.nl/post/sort-descriptors-in-swift/
//TODO: simplify
enum SortDescriptor {
    typealias SortDescriptor<Value> = (Value, Value) -> Bool

    static private func combine<Value>
        (sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
        return { lhs, rhs in
            for isOrderedBefore in sortDescriptors {
                if isOrderedBefore(lhs, rhs) { return true }
                if isOrderedBefore(rhs, lhs) { return false }
            }
            return false
        }
    }

    static let sortByTitle: SortDescriptor<Movie> = { $0.title < $1.title }
    static let sortByListPosition: SortDescriptor<Movie> = { $0.listPosition < $1.listPosition }
    static let sortByWatchedDate: SortDescriptor<Movie> = {
        if let date1 = $0.watchedDate,
            let date2 = $1.watchedDate {
            return date1 > date2
        } else {
            return $0.title < $1.title
        }
    }

    static let sortByListPositionAndTitle: SortDescriptor<Movie> = combine(
        sortDescriptors: [sortByListPosition, sortByTitle]
    )
}
