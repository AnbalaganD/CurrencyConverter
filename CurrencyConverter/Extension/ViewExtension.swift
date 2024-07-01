//
//  ViewExtension.swift
//  CurrencyConverter
//
//  Created by Anbalagan D on 26/07/23.
//

import SwiftUI

extension View {
    func scrollable(_ axis: Axis.Set = .vertical, showsIndicators: Bool = true) -> some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            self
        }
    }
}
