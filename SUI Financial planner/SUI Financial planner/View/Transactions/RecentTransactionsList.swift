import SwiftUI

struct RecentTransactionsList: View {
    @Environment(\.locale) var locale
    @EnvironmentObject var appSettings: AppSettings
    private var transactions: [Transaction]
    private var onDelete: ([String]) -> Void

    init(
        transactions: [Transaction],
        onDelete: @escaping ([String]) -> Void
    ) {
        self.transactions = transactions.sorted(by: { $0.date > $1.date })
        self.onDelete = onDelete
    }

    var body: some View {
        VStack {
            HStack {
                // MARK: Header title
                Text("recentTransactions".localized(locale.identifier))
                    .bold()
                
                Spacer()
                
                // MARK: Header link
                NavigationLink {
                    TransactionsList(transactions: transactions, onDelete: onDelete)
                } label: {
                    HStack(spacing: 4) {
                        Text("all".localized(locale.identifier))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color.assetsText)
                }
            }
            .padding(.top)
            
            // MARK: - Recent transactions list
            ForEach(Array(transactions.prefix(5).enumerated()), id: \.element.id) {
                index,
                transaction in
                TransactionRow(
                    transaction: transaction,
                    currencyCode: CurrencyCode(rawValue: appSettings.currencyCode) ?? .rub
                )
                .id(UUID())

                Divider()
                    .opacity(index == 4 ? 0 : 1)
            }
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//        .shadow(color: .gray, radius: 8)
    }
}

#Preview {
    NavigationView {
        RecentTransactionsList(
            transactions: [Transaction(
                description: "Description",
                amount: 1234,
                category: .car,
                isExpense: true
            )], 
            onDelete: { _ in }
        )
    }
}
