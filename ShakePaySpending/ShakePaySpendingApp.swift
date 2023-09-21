//
//  ShakePaySpendingApp.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-17.
//

import SwiftUI

@main
struct ShakePaySpendingApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { ViewModel() }) { config in
            ContentView(viewModel: config.document)
        }
    }
}
