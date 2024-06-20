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

    // This will be Remove if we changed minimum target version into iOS 15.0
    public func task(
        priority: TaskPriority = .userInitiated,
        _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        self.onAppear {
            Task(priority: priority) {
                await action()
            }
        }
    }
}
