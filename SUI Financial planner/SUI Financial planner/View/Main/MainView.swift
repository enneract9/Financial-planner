import SwiftUI
import SwiftUICharts

struct MainView: View {

    @Environment(\.locale) var locale
    @EnvironmentObject var appSettings: AppSettings
    @ObservedObject var transactionListViewModel: TransactionListViewModel

    @State private var isAddingExpense = false
    @State private var isAddingIncome = false

    private var prefixSum: TransactionPrefixSum {
        transactionListViewModel.transactions.makeTransactionPrefixSum()
    }
    private var imcomesAmount: Double {
        transactionListViewModel.transactions.incomesSum()
    }
    private var expensesAmount: Double {
        transactionListViewModel.transactions.expensesSum()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Header()
                    ChartWithButtons()
                    RecentTransactionsList(
                        transactions: transactionListViewModel.transactions,
                        onDelete: transactionListViewModel.remove
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .automatic)
            .scrollIndicators(.never)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.assetsBackground, .gray]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(Color.assetsText)
        .presentationCornerRadius(20)
        .sheet(isPresented: $isAddingIncome) {
            AddTransactionView(
                isExpense: false,
                onTapSave: { transaction in
                    transactionListViewModel.add(transaction)
                }
            )
        }
        .sheet(isPresented: $isAddingExpense) {
            AddTransactionView(
                isExpense: true,
                onTapSave: { transaction in
                    transactionListViewModel.add(transaction)
                }
            )
        }
    }

    @ViewBuilder
    private func Header() -> some View {
        Text("mainView.title".localized(locale.identifier))
            .font(.title)
            .bold()
    }

    @ViewBuilder 
    private func ChartWithButtons() -> some View {
        HStack(spacing: 12) {
            CurrentBalanceBarChart(
                data: prefixSum, 
                currency: CurrencyCode(rawValue: appSettings.currencyCode) ?? .rub
            )
            .id(UUID())
            .allowsHitTesting(prefixSum.isNotEmpty)

            VStack(spacing: 12) {
                AddTransactionButton(
                    amount: imcomesAmount,
                    currency: CurrencyCode(rawValue: appSettings.currencyCode) ?? .rub,
                    type: .incomes
                ) {
                    withAnimation {
                        isAddingIncome = true
                    }
                }

                AddTransactionButton(
                    amount: expensesAmount,
                    currency: CurrencyCode(rawValue: appSettings.currencyCode) ?? .rub,
                    type: .outcomes
                ) {
                    withAnimation {
                        isAddingExpense = true
                    }
                }
            }
        }
    }


}
//
//#Preview {
//    @State var transactions: [Transaction] = [
//        Transaction(
//            description: "Description",
//            amount: 1234,
//            category: .car,
//            isExpense: true
//        )
//    ]
//
////    return MainView(transactionListViewModel: $transactions)
//}
