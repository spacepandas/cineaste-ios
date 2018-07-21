//
//  IndexPath+Last.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

extension IndexPath {
    func isLast(of numberOfElements: Int) -> Bool {
        return row == numberOfElements - 1
    }
}
