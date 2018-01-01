//
//  WantToSeeMoviesSource.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

final class WantToSeeMoviesSource: NSObject {
    var fetchedObjects: [StoredMovie] = []
}

extension WantToSeeMoviesSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedObjects.isEmpty {
            return 1
        }
        return fetchedObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fetchedObjects.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyMoviesCell.identifier, for: indexPath) as? EmptyMoviesCell
                else {
                    fatalError("Unable to dequeue cell for identifier: \(EmptyMoviesCell.identifier)")
            }

            cell.category = .wantToSee
            cell.layer.backgroundColor = UIColor.clear.cgColor

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WantToSeeListCell.identifier, for: indexPath) as? WantToSeeListCell
                else {
                    fatalError("Unable to dequeue cell for identifier: \(WantToSeeListCell.identifier)")
            }

            cell.configure(with: fetchedObjects[indexPath.row])

            return cell
        }
    }
}
