//
//  MoviesViewControllerDelegate.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

protocol FetchedResultsManagerDelegate: AnyObject {
    func beginUpdate()
    func insertRows(at index: [IndexPath])
    func updateRows(at index: [IndexPath])
    func deleteRows(at index: [IndexPath])
    func moveRow(at index: IndexPath, to newIndex: IndexPath)
    func endUpdate()
}
