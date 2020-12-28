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
    /// To decode any Decodable for a given key.
    /// - Parameter key: The key in the json
    /// - Throws: When decoding is not successful
    /// - Returns: The decoded object
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    /// To decode any Decodable for a given key, when the key is present.
    /// - Parameter key: The key in the json
    /// - Throws: When the key is present but decoding is not successful
    /// - Returns: The decoded object if key is present, nil if the key is not present
    func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }

    /// To decode any Decodable for a given key, when the key is not present it uses a default expression.
    /// - Parameters:
    ///   - key: The key in the json
    ///   - defaultExpression: The default expression which should be used when key is not present
    /// - Throws: When the key is present but decoding is not successful
    /// - Returns: The decoded object if key is present, the default expression if the key is not present
    func decode<T: Decodable>(
        forKey key: Key,
        default defaultExpression: @autoclosure () -> T
        ) throws -> T {
        try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
}
