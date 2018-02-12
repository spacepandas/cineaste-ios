//
//  SearchMoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultSearchController.dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = movies[indexPath.section]
        perform(segue: .showMovieDetail, sender: self)
    }
}

extension SearchMoviesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMoviesCell.identifier, for: indexPath) as? SearchMoviesCell else {
            fatalError("Unable to dequeue cell for identifier: \(SearchMoviesCell.identifier)")
        }

        cell.movie = movies[indexPath.section]
        cell.delegate = self
        return cell
    }
}
