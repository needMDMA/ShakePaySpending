//
//  ContentView.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    
    var body: some View {
        ZStack {
            if isLoaded {
                NavigationView {
                    List(viewModel.years, id: \.self) { year in
                        NavigationLink(year, destination: months(for: year))
                    }
                    Text("Select a Year")
                }
            } else {
                importButton
            }
        }.frame(minWidth: 800, minHeight: 400)
    }
    
    var isLoaded: Bool {
        if viewModel.viewModel.statement.isEmpty {
            return false
        }
        return true
    }
    
    var importButton: some View {
        Button {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            if panel.runModal() == .OK {
                if let url = panel.url {
                    viewModel.loadStatement(url: url)
                }
            }
        } label: {
            Text("Import Statement (Only ShakePay)")
        }
    }
    
    @ViewBuilder
    func months(for year: String) -> some View {
        NavigationView {
            List(viewModel.months(for: year), id: \.self) { month in
                NavigationLink(month, destination: cardTransactions(year, month))
            }
            Text("Select a Month")
        }
    }
    
    @ViewBuilder
    func cardTransactions(_ year: String, _ month: String) -> some View {
        let cardTransactions = viewModel.getCardTransactions(year, month)
        Table(cardTransactions) {
            TableColumn("Date", value: \.date).width(100)
            TableColumn("Description", value: \.description).width(200)
            TableColumn("Debit", value: \.debit).width(60)
            TableColumn("Credit", value: \.credit).width(60)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(viewModel: )
//    }
//}
