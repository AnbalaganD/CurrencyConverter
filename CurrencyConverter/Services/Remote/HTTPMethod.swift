//
//  HTTPMethod.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

struct HTTPMethod {
    let rawValue: String
}

extension HTTPMethod {
    static let get = HTTPMethod(rawValue: "GET")
    
    static let post = HTTPMethod(rawValue: "POST")
}
