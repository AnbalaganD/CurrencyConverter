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

extension String: URLConvertible {
    func asURL() -> URL? {
        URL(string: self)
    }
}

extension URL: URLConvertible {
    func asURL() -> URL? {
        self
    }
}
