//
//  Either.swift
//  Cineaste
//
//  Created by Christian Braun on 27.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

enum SuccessOrError<SuccessType> {
    case success(SuccessType)
    case error(Error)
}
