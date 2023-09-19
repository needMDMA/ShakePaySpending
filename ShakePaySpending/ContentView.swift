//
//  ContentView.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ViewModel: ViewModel
    var body: some View {
        NavigationView {
            List(ViewModel.years, id: \.self) { year in
                NavigationLink(year, destination: months(for: year))
            }
            Text("Select a Year")
        }
    }
    
    @ViewBuilder
    func months(for year: String) -> some View {
        NavigationView {
            List(ViewModel.months(for: year), id: \.self) { month in
                NavigationLink(month, destination: cardTransactions(year, month))
            }
            Text("Select a Month")
        }
    }
    
    @ViewBuilder
    func cardTransactions(_ year: String, _ month: String) -> some View {
        let cardTransactions = ViewModel.getCardTransactions(year, month)
        Table(cardTransactions) {
            TableColumn("Date", value: \.date)
            TableColumn("Description", value: \.description)
            TableColumn("Debit", value: \.debit)
            TableColumn("Credit", value: \.credit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
