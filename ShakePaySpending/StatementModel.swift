//
//  StatementModel.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-17.
//

import Foundation
import TabularData

struct StatementModel {
    private var dataFrame: DataFrame = DataFrame()
    
    public var statement: DataFrame {
        dataFrame
    }
    
    init(csvData: Data) throws {
        let options = CSVReadingOptions(hasHeaderRow: true)
        dataFrame = try DataFrame(
            csvData: csvData,
            columns: ["Date", "Source / Destination", "Amount Debited", "Amount Credited", "Transaction Type"],
            options: options
            )
        
        // add a category columsn
    }
    
    init() { }
}
