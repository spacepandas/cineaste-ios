//
//  StoredMovie+Networking.swift
//  Cineaste App-Dev
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension StoredMovie {
    func loadPoster(completionHandler handler: @escaping (_ poster: Data?) -> Void) {
        guard let posterPath = posterPath else {
            handler(nil)
            return
        }

        Webservice.load(resource: Movie.loadPoster(from: posterPath)) { result in
            guard case let .success(image) = result else {
                handler(nil)
                return
            }
            let data = UIImageJPEGRepresentation(image, 1)
            handler(data)
        }
    }
}
