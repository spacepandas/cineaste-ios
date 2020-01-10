//
//  Decoding.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 29.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

// credits:
// https://www.swiftbysundell.com/articles/type-inference-powered-serialization-in-swift/

extension KeyedDecodingContainerProtocol {
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }

    func decode<T: Decodable>(
        forKey key: Key,
        default defaultExpression: @autoclosure () -> T
        ) throws -> T {
        try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
}
