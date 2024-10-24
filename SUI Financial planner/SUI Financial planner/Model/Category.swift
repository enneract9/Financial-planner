import SwiftUIFontIcon
import SwiftUI
import Foundation

enum Category: String, Codable {

    static let incomes: [Category] = [
        .salary, .gift, .dividends
    ]
    
    static let expenses: [Category] = [
        .car, .taxes, .entertainment, .foodAndDining,
        .home, .shopping, .publicTransportation, .taxi,
        .mobilePhone, .groceries, .restaurants, .rent,
        .homeSupplies, .creditCardPayment, .gifts
    ]
    
    static let all = incomes + expenses
    
    // Incomes
    case salary = "Salary"
    case gift = "Gift"
    case dividends = "Dividends"
    
    // Expenses
    case car = "Car"
    case taxes = "Taxes"
    case entertainment = "Entertainment"
    case foodAndDining = "Food & Dining"
    case home = "Home"
    case shopping = "Shopping"
    case publicTransportation = "Public Transportation"
    case taxi = "Taxi"
    case mobilePhone = "Mobile phone"
    case groceries = "Groceries"
    case restaurants = "Restaurants"
    case rent = "Rent"
    case homeSupplies = "Home Supplies"
    case creditCardPayment = "Credit Payment"
    case gifts = "Gifts"

    func localized(_ languageCode: String) -> String {
        return self.rawValue.localized(languageCode)
    }

    var iconCode: FontAwesomeCode {
        switch self {
        case .salary: 
            return .dollar_sign
        case .gift:
            return .gift
        case .dividends: 
            return .money_check
        case .car: 
            return .car_alt
        case .taxes:
            return .file_invoice_dollar
        case .entertainment:
            return .film
        case .foodAndDining:
            return .hamburger
        case .home:
            return .home
        case .shopping:
            return .shopping_bag
        case .publicTransportation:
            return .bus
        case .taxi:
            return .taxi
        case .mobilePhone:
            return .mobile_alt
        case .groceries:
            return .shopping_basket
        case .restaurants:
            return .utensils
        case .rent:
            return .house_user
        case .homeSupplies:
            return .lightbulb
        case .creditCardPayment:
            return .credit_card
        case .gifts:
            return .gifts
        }
    }

    var color: Color {
        switch self {
        case .salary:
            return .green
        case .gift:
            return .cyan
        case .dividends:
            return .blue
        case .car:
            return .red
        case .taxes:
            return .purple
        case .entertainment:
            return .orange
        case .foodAndDining:
            return .cyan
        case .home:
            return .brown
        case .shopping:
            return .indigo
        case .publicTransportation:
            return .mint
        case .taxi:
            return .yellow
        case .mobilePhone:
            return .teal
        case .groceries:
            return .green.opacity(0.7)
        case .restaurants:
            return .indigo
        case .rent:
            return .brown
        case .homeSupplies:
            return .blue
        case .creditCardPayment:
            return .gray
        case .gifts:
            return .pink
        }
    }
}
