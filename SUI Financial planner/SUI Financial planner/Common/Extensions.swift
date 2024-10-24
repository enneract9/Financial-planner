import SwiftUI
import Foundation
import SwiftUICharts

extension Color {
    static let assetsBackground = Color("Background")
    static let assetsIcon = Color("Icon")
    static let assetsText = Color("Text")
    static let assetsBlock = Color("Block")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    static let allNumericRU: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter
    }()
    
    static let allNumericUSA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else { return Date() }
        
        return parsedDate
    }
}

extension Double {
    func roundedTo2Digits() -> Double {
        return (self * 100).rounded() / 100
    }
}

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}

extension Collection {
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

extension Array where Element == Transaction {
    /// Создает словарь транзакций, сгрупированных по месяцу и году
    func makeTransactionGroupByDate(ascending: Bool = false) -> TransactionGroup {
        guard self.isNotEmpty else {
            return [:]
        }

        let sorted = self.sorted(by: { ascending ? $0.date < $1.date : $0.date > $1.date })

        return TransactionGroup(grouping: sorted) { $0.monthAndYear }
    }

    /// Создает прификсную сумму транзакций для создания к графиков
    func makeTransactionPrefixSum() -> TransactionPrefixSum {
        guard self.isNotEmpty else {
            return []
        }

        let today = Date()
        let day: TimeInterval = 60 * 60 * 24
        let month: TimeInterval = day * 30
        let dateInterval = DateInterval(start: today.addingTimeInterval(-month), duration: month)
        var sum: Double = 0
        var cumulativeSum = TransactionPrefixSum()

        for date in stride(from: dateInterval.start, through: today, by: day) {
            let formattedDate = date.formatted(date: .numeric, time: .omitted)
            let dailyTotal = self.filter{ $0.numericFormattedDate == formattedDate }.reduce(0) { $0 + $1.signedAmount }
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date, sum))
        }

        if let startDate = cumulativeSum.first(where: { $0.amount != 0 })?.date {
            cumulativeSum.removeAll(where: { $0.date < startDate })
        }

        return cumulativeSum
    }

    /// Cумма доходов
    func incomesSum() -> Double {
        self.filter{ $0.isExpense == false }.reduce(0) { $0 + $1.amount }
    }

    /// Сумма расходов
    func expensesSum() -> Double {
        self.filter{ $0.isExpense == true }.reduce(0) { $0 + $1.amount }
    }
}
