import SwiftUI

struct TransactionsList: View {
    @Environment(\.locale) var locale
    @EnvironmentObject var appSettings: AppSettings
    private var transactions: [Transaction]
    private var onDelete: ([String]) -> Void

    init(
        transactions: [Transaction],
        onDelete: @escaping ([String]) -> Void
    ) {
        self.transactions = transactions
        self.onDelete = onDelete
    }

    var body: some View {
        VStack {
            List {
                ForEach(Array(transactions.makeTransactionGroupByDate()), id: \.key)
                {
                    month,
                    transactions in
                    Section {
                        // MARK: Transaction list
                        ForEach(transactions) { transaction in
                            TransactionRow(
                                transaction: transaction,
                                currencyCode: CurrencyCode(rawValue: appSettings.currencyCode) ?? .rub
                            )
                        }
                        .onDelete { indexSet in
                            let IDs = indexSet.map { transactions[$0].id }
                            onDelete(IDs)
                        }
                    } header: {
                        // MARK: Transaction month
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("transactions".localized(locale.identifier))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TransactionsList(
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
