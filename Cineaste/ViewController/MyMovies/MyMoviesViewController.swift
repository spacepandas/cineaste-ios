//
//  MyMoviesViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 02.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData
class MyMoviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let request: NSFetchRequest = StoredMovie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let movies = try? AppDelegate.viewContext.fetch(request)

        movies?.forEach {movie in
            print(movie.title)
        }

    }
}
