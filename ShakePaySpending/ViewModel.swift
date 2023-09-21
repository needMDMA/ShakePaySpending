//
//  ViewModel.swift
//  ShakePaySpending
//
//  Created by Olivier Lambert Rouillard on 2023-09-18.
//

import Foundation
import TabularData
import SwiftUI
import UniformTypeIdentifiers

class ViewModel: ReferenceFileDocument {
    func snapshot(contentType: UTType) throws -> Data {
        try viewModel.statement.csvRepresentation()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: snapshot)
    }
        
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            viewModel = try StatementModel(csvData: data)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    init() {

    }
    
    @Published var viewModel: StatementModel = StatementModel()
    
    var cardTransactions: DataFrame.Slice {
        viewModel.statement.filter(on: "Transaction Type", String.self) { $0 == "card transactions"}
    }
    
    var years: [String] {
        let years = cardTransactions["Date"].map { date in
            if let date = date as? Date {
                let dateComponents = Calendar.current.dateComponents([.day, .year, .month], from: date)
                if let elem = dateComponents.year {
                    return String(elem)
                }
            }
            return ""
        }
        return Array(Set(years).sorted())
    }
    
    func months(for year: String) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let targetDate = dateFormatter.date(from: year)!
        let targetDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: targetDate)
        
        let yearData = viewModel.statement.filter(on: "Date", Date.self) { date in
            if let date = date {
                let sourceDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: date)
                if sourceDateComponents.year == targetDateComponents.year {
                    return true
                }
            }
            return false
        }
        
        var months: [Int] = yearData["Date"].map { date in
            if let date = date as? Date {
                let sourceDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: date)
                if let elem = sourceDateComponents.month {
                    return elem
                }
            }
            return -1
        }
        months = months.filter { $0 > 0 }
        months = Array(Set(months)).sorted()
        return months.map { Calendar.current.monthSymbols[$0-1] }
    }
    
    func getCardTransactions(_ year: String, _ month: String) -> [CardTransaction] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM"
        let targetDate = dateFormatter.date(from: "\(year)/\(month)")!
        let targetDateComponents = Calendar.current.dateComponents([.year, .month], from: targetDate)
        
        var filteredTransactions: [CardTransaction] = []

        let cardTransactions = cardTransactions
        var index = cardTransactions.rows.startIndex
        while index != cardTransactions.rows.endIndex-1 {
            let transaction = cardTransactions.rows[index]

            if let sourceDate = transaction["Date"] as? Date {
                let sourceDateComponents = Calendar.current.dateComponents([.year, .month], from: sourceDate)
                if sourceDateComponents.year == targetDateComponents.year && sourceDateComponents.month == targetDateComponents.month {

                    dateFormatter.dateFormat = "dd MMMM yyyy"
                    let dateString = dateFormatter.string(from: sourceDate)

                    var description: String {
                        if let description = transaction["Source / Destination"] as? String {
                            return description
                        }
                        return ""
                    }

                    var debit: String {
                        if let debit = transaction["Amount Debited"] as? Double {
                            return String(debit)
                        }
                        return ""
                    }

                    var credit: String {
                        if let credit = transaction["Amount Credited"] as? Double {
                            return String(credit)
                        }
                        return ""
                    }

                    let cardTransaction = CardTransaction(
                        date: dateString,
                        description: description,
                        debit: debit,
                        credit: credit
                    )
                    filteredTransactions.append(cardTransaction)
                }
            }
            index = cardTransactions.rows.index(after: index)
        }
        return filteredTransactions
    }
    
    func loadStatement(url: URL) {
        viewModel.loadDataFrame(url: url)
    }
    
    struct CardTransaction: Identifiable {
        let date: String
        let description: String
        let debit: String
        let credit: String
        let id = UUID()
    }
    
}
