//
//  BodyConvertible.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

protocol BodyConvertible: Encodable {
    func asBody(from encoder: JSONEncoder) throws -> Data
}

extension BodyConvertible where Self == Data {
    func asBody(from encoder: JSONEncoder) throws -> Data {
        self
    }
}

extension Data: BodyConvertible { }

extension BodyConvertible {
    func asBody(from encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }
}
