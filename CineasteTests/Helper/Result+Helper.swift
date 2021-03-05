//
//  Result+Helper.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 03.02.21.
//  Copyright © 2021 spacepandas.de. All rights reserved.
//

extension Result {
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }

    var error: Failure? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
