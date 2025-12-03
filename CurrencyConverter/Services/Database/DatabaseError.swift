//
//  DatabaseError.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 09/07/23.
//

import Foundation

enum DatabaseError: Error {
    case emptyLocalData
    case saveError(reason: String)
    case retrieveError(reason: String)
}
