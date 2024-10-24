//
//  CategoriesList.swift
//  SUI Financial planner
//
//  Created by Ivan Vargunin on 14.10.2024.
//

import SwiftUI

struct CategoriesList: View {

    @Environment(\.locale) var locale

    typealias CategoriesListPresentable = [(category: Category, amount: Double, count: Int)]

    @State var data: CategoriesListPresentable
    @State var currency: CurrencyCode
    @State private var showFullList: Bool

    init(data: CategoriesListPresentable, currency: CurrencyCode) {
        self.data = data.sorted(by: { $0.amount > $1.amount } )
        self.currency = currency
        self.showFullList = data.count < 4
    }

    var body: some View {
        VStack(alignment: .trailing) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                if showFullList || index < 3 {
                    CategoryRow(
                        category: item.category,
                        amount: item.amount,
                        count: item.count,
                        currencyCode: currency
                    )
                }
            }

            if data.count > 3 {
                ShowFullListButton()
            }
        }
    }

    private func ShowFullListButton() -> some View {
        let text = showFullList
        ? "Свернуть".localized(locale.identifier)
        : "Развернуть".localized(locale.identifier)

        return Button {
            withAnimation {
                showFullList.toggle()
            }
        } label: {
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Material.regular)
        )
    }
}

#Preview {
    let data: CategoriesList.CategoriesListPresentable = [
        (category: .car, amount: 2.12, count: 1),
        (category: .dividends, amount: 2.121, count: 21),
        (category: .gifts, amount: 23.1224, count: 13),
        (category: .groceries, amount: 23.1224, count: 13),
    ]

    return CategoriesList(data: data, currency: .rub).padding()
}
