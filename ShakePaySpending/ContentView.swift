//
//  ContentView.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-17.
//

import SwiftUI

struct row: Identifiable {
//    let date: Date = Date()
    let description: String = "Description"
    let debit: Double
    let credit: String = "100.0"
    let id = UUID()
    
    var debitString: String {
        "\(debit)"
    }
}

struct ContentView: View {
    let rows = Array(repeating: row(debit: 10.2), count: 10)
    var body: some View {
        Table(rows) {
            TableColumn("Description", value: \.description).width(max: 100)
            TableColumn("Debit", value: \.debitString).width(max: 60)
            TableColumn("Credit", value: \.credit).width(max: 60)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
