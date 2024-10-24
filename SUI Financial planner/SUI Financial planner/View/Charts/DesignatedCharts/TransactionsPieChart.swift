import SwiftUI

struct TransactionsPieChart: View {

    typealias Presentable = [(dateString: String, pieGraphPresentable: PieGraphPresentable, categoriesListPresentable: CategoriesList.CategoriesListPresentable)]
    typealias PieGraphPresentable = [(value: Double, color: Color, name: String)]

    @Environment(\.locale) var locale

    private let currency: CurrencyCode
    private let showsExpenses: Bool
    private let data: Presentable

    init(
        data: TransactionGroup, // [дата:[транзакции]]
        currency: CurrencyCode,
        showsExpenses: Bool
    ) {
        self.data = data
            .compactMap { dateString, transactions in
                let filteredTransactions = transactions.filter { $0.isExpense == showsExpenses }
                guard filteredTransactions.isNotEmpty else { return nil }

                return (
                    dateString,
                    filteredTransactions.mapToPieGraphPresentable(),
                    filteredTransactions.mapToCategoriesListPresentable()
                )
            }
        self.currency = currency
        self.showsExpenses = showsExpenses
    }

    var body: some View {
        ScrollPieGraph(data: data)
    }

    private func ScrollPieGraph(data: Presentable) -> some View {
        var data = data
        let currentDate: String = Date().formatted(.dateTime.year().month(.wide))

        if data.isEmpty || !data.contains(where: { $0.dateString == currentDate }) {
            data.append((currentDate, [], []))
        }

        let placeholder = showsExpenses
            ? "transactionsPieChart.placeholder.expenses".localized(locale.identifier)
            : "transactionsPieChart.placeholder.incomes".localized(locale.identifier)

        return ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(Array(data.enumerated()), id: \.element.dateString) {
                        index,
                        item in
                        VStack {
                            AnnotatedPieChartView(
                                data: item.pieGraphPresentable,
                                title:
                                    String(
                                        format: "%.2f",
                                        item.pieGraphPresentable.reduce(0, { $0 + $1.value })
                                    ),
                                annotation: item.dateString,
                                cornerImage: currency.image,
                                placeholder: placeholder,
                                dropShadow: false
                            )
                            .id(index)
                            .overlay(alignment: .leading) {
                                if index > 0 {
                                    LeftScrollButton(proxy: proxy, id: index)
                                }
                            }
                            .overlay(alignment: .trailing) {
                                if index < data.count - 1 {
                                    RightScrollButton(proxy: proxy, id: index)
                                }
                            }

                            CategoriesList(
                                data: item.categoriesListPresentable,
                                currency: currency
                            )
                            .frame(width: 360)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(data.count == 1)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            .scrollIndicators(.never)
            .onAppear {
                proxy.scrollTo(data.count - 1)
            }
        }
        .padding()
        .id(UUID())
    }

    private func LeftScrollButton(proxy: ScrollViewProxy, id: Int) -> some View {
        Button {
            withAnimation {
                proxy.scrollTo(id - 1)
            }
        } label: {
            Image(systemName: "arrow.left")
                .imageScale(.large)
        }
        .padding(.leading)
    }

    private func RightScrollButton(proxy: ScrollViewProxy, id: Int) -> some View {
        Button {
            withAnimation {
                proxy.scrollTo(id + 1)
            }
        } label: {
            Image(systemName: "arrow.right")
                .imageScale(.large)
        }
        .padding(.trailing)
    }
}

extension Array where Element == Transaction {
    fileprivate func mapToPieGraphPresentable() -> TransactionsPieChart.PieGraphPresentable {

        let groups = Dictionary(grouping: self) { $0.category }

        return groups.map { group in
            let value = group.value.reduce(0, { $0 + $1.amount })
            return (value, group.key.color, group.key.rawValue)
        }
    }

    fileprivate func mapToCategoriesListPresentable() -> CategoriesList.CategoriesListPresentable {

        let groups = Dictionary(grouping: self) { $0.category }

        return groups.map { group in
            let amount = group.value.reduce(0, { $0 + $1.amount })
            return (category: group.key, amount: amount, count: group.value.count)
        }
    }
}

#Preview {
    let transactions: [Transaction] = [
        Transaction(description: "", amount: 1, category: .car, isExpense: true),
        Transaction(description: "", amount: 1, category: .car, isExpense: true),
        Transaction(description: "", amount: 2, category: .creditCardPayment, isExpense: true),
        Transaction(description: "", amount: 2, category: .creditCardPayment, isExpense: true, date: Date(timeIntervalSince1970: 24124221221)),
        Transaction(description: "", amount: 2, category: .gifts, isExpense: true, date: Date(timeIntervalSince1970: 34134221231)),
    ]

    return TransactionsPieChart(
        data: transactions.makeTransactionGroupByDate(),
        currency: .rub,
        showsExpenses: true
    )
}
