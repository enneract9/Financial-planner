import Foundation

struct Transaction: Identifiable {
    
    // MARK: - Stored properties
    let id: String
    let description: String
    let amount: Double
    let category: Category
    let isExpense: Bool
    let date: Date
    
    // MARK: - Computed properties    
    var signedAmount: Double {
        return isExpense ? -amount : amount
    }
    
    var monthAndYear: String {
        date.formatted(.dateTime.year().month(.wide))
    }
    
    var numericFormattedDate: String {
        date.formatted(date: .numeric, time: .omitted)
    }
    
    var longFormattedDate: String {
        date.formatted(.dateTime.year().month().day())
    }
    
    // MARK: - Initilizers
    init(description: String,
         amount: Double,
         category: Category,
         isExpense: Bool,
         date: Date = Date()
    ) {
        self.id = UUID().uuidString
        self.date = date
        self.description = description
        self.amount = amount
        self.category = category
        self.isExpense = isExpense
    }
}

extension Transaction: Codable {}

extension Transaction: Hashable {}
