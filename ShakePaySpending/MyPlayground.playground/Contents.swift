import Foundation
import TabularData


var url = URL(filePath: "/Users/olivierlambertrouillard/Downloads/transactions_summary.csv")
var data = DataFrame()

let options = CSVReadingOptions(hasHeaderRow: true)

do {
    data = try DataFrame(
        contentsOfCSVFile: url,
        columns: ["Date", "Source / Destination", "Amount Debited", "Amount Credited", "Transaction Type"],
        options: options
    )
} catch {
    print("failed")
}

var cardTransactions = data.filter(on: ColumnID("Transaction Type", String.self)) { $0 == "card transactions"}

var new = cardTransactions["Date"].map { date in
    if let date = date as? Date {
        let dateComponents = Calendar.current.dateComponents([.day, .year, .month], from: date)
        if let elem = dateComponents.year {
            return elem
        }
    }
    return 0
}
print(Set(new).sorted())


cardTransactionsYear = cardTransactions.filter(on: "Date", Date.self) { date in
    if let date = as? Date {
        
    }
}

//// Create String
//let string = "2023/07/01"
//// Create Date Formatter
//let dateFormatter = DateFormatter()
//// Set Date Format
//dateFormatter.dateFormat = "yyyy/MM/dd"
//// Convert String to Date
//let targetDate = dateFormatter.date(from: string)!
//let targetDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: targetDate)
//targetDateComponents
//
//
////func getList(dateColumn: AnyColumnSlice, dateComponents: DateComponents) -> [Int] {
////    var list: [Int] = []
////    for date in dateColumn {
////        if let date = date as? Date {
//////            let dateComponents = Calendar.current.dateComponents([.day, .year, .month], from: date)
////            if let year = dateComponents.month {
////
////            }
////        }
////    }
////}
//
//Calendar.current.shortWeekdaySymbols
//
//
////print(monthList.sorted())
////print(yearList.sorted())
