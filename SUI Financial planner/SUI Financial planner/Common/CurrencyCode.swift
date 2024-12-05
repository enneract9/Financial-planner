import SwiftUI

enum CurrencyCode: String {
    case rub = "RUB"
    case usd = "USD"
    
    var image: Image {
        return switch self {
        case .rub:
            Image(systemName: "rublesign")
        case .usd:
            Image(systemName: "dollarsign")
        }
    }
}
