//
//  RemoteError.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 06/07/23.
//

import Foundation

enum RemoteError: Error {
    case invalidURL
    case invalidBody
    case parsingError(reason: String)
    case general(status: String, statusCode: Int)
}
