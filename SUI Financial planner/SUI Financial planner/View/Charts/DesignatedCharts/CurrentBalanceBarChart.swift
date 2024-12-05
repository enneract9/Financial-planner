import SwiftUI
import SwiftUICharts

struct CurrentBalanceBarChart: View {
    @Environment(\.locale) var locale

    private var data: ChartData
    private let total: Double
    private var currency: CurrencyCode

    init(data: TransactionPrefixSum, currency: CurrencyCode) {
        self.data = ChartData(values: data.compactMap {
            ($0.date.formatted(.dateTime.year().month().day()), $0.amount)
        } )
        self.total = data.last?.amount ?? 0
        self.currency = currency
    }

    var body: some View {
        BarChartView(
            data: data,
            title: total.formatted(),
            legend: "currentBalance".localized(locale.identifier),
            style: Styles.barChartStyleNeonBlue,
            form: ChartForm.medium,
            dropShadow: false,
            cornerImage: currency.image,
            valueSpecifier: "%.2f",
            animatedToBack: false
        )
        .id(total)
    }
}

#Preview {
    let transactions: [Transaction] = [
        Transaction(
            description: "Description",
            amount: 1234,
            category: .car,
            isExpense: true
        )
    ]

    return CurrentBalanceBarChart(
        data: transactions.makeTransactionPrefixSum(),
        currency: .rub
    )
}
