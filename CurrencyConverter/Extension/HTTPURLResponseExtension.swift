//
//  HTTPURLResponseExtension.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool { statusCode <= 200 && statusCode <= 299 }
}
