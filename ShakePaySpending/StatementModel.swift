//
//  StatementModel.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-17.
//

import Foundation
import TabularData

struct StatementModel {
    private let url = URL(filePath: "/Users/\(NSUserName())/Downloads/transactions_summary.csv")
    private(set) var statement: DataFrame
    
    init() {
        let options = CSVReadingOptions(hasHeaderRow: true)

        do {
            statement = try DataFrame(
                contentsOfCSVFile: url,
                columns: ["Date", "Source / Destination", "Amount Debited", "Amount Credited", "Transaction Type"],
                options: options
            )
        } catch {
            print(error)
            statement = DataFrame()
            print("failed")
        }
    }
}
