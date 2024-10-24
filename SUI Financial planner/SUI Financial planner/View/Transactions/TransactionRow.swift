import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    @Environment(\.locale) var locale
    @State private var transaction: Transaction
    @State private var currencyCode: CurrencyCode

    init(transaction: Transaction, currencyCode: CurrencyCode) {
        self.transaction = transaction
        self.currencyCode = currencyCode
    }

    var body: some View {
        HStack() {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.assetsIcon)
                .opacity(0.3)
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.category.iconCode), fontsize: 24, color: Color.assetsIcon)
                }
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 6) {
                // MARK: Transaction description
                Text(transaction.description)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(2)
                
                // MARK: Transaction Category
                Text(transaction.category.localized(locale.identifier))
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                // MARK: Transaction Date
                Text(transaction.longFormattedDate)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer(minLength: 20)
            
            // MARK: Transaction Ammount
            Text(transaction.signedAmount, format: .currency(code: currencyCode.rawValue))
                .bold()
                .foregroundStyle(
                    transaction.isExpense ? Color.primary : Color.assetsText
                )
                .lineLimit(2)
        }
        .padding([.top, .bottom], 8)
    }
}
//
//#Preview {
//    TransactionRow(
//        transaction: Transaction(
//            description: "Description",
//            amount: 1234,
//            category: .car,
//            isExpense: true
//        )
//    )
//}
