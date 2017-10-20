//
//  ViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 16.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var managedContext:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupData() {
        guard let managedContext = managedContext else {
            fatalError("ManagedContext not set")
        }
        let request = Movie.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest:request, managedObjectContext:managedContext, sectionNameKeyPath:nil, cacheName:nil)
    }

}

