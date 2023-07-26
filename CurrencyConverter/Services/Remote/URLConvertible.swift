//
//  URLConvertible.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

protocol URLConvertible {
    func asURL() -> URL?
}

extension URLConvertible where Self == String {
    func asURL() -> URL? {
        URL(string: self)
    }
}

extension URLConvertible where Self == URL {
    func asURL() -> URL? {
        self
    }
}

extension String: URLConvertible { }

extension URL: URLConvertible { }
