import SwiftUI

enum AddTransactionButtonType {
    case incomes
    case outcomes
    
    func label(languageCode: String) -> String {
        switch self {
        case .incomes:
            "incomes".localized(languageCode)
        case .outcomes:
            "expenses".localized(languageCode)
        }
    }
}

struct AddTransactionButton: View {
    
    // MARK: - Properties

    @Environment(\.locale) var locale

    var amount: Double
    var currency: CurrencyCode
    let type: AddTransactionButtonType
    let onTap: () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                label(text: type.label(languageCode: locale.identifier))
                Spacer()
                plusButton(onTap: onTap)
            }
            amount(amount, currencyCode: currency)
            
        }
        .frame(height: 82)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//        .shadow(color: .gray, radius: 8)
    }
    
    // MARK: - Subviews
    
    private func label(text: String) -> some View {
        Text(text)
            .font(.title3)
            .lineLimit(1)
    }
    
    private func plusButton(onTap: @escaping () -> ()) -> some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(Color.assetsText)
                .font(.system(size: 32))
        }
    }
    
    private func amount(_ amount: Double, currencyCode: CurrencyCode) -> some View {
        Text(amount, format: .currency(code: currencyCode.rawValue))
            .font(.subheadline)
            .bold()
            .lineLimit(2)
    }
}

#Preview {
    @State var amount = 123.12314

    return NavigationView {
        AddTransactionButton(
            amount: amount,
            currency: .rub,
            type: .incomes,
            onTap: {}
        )
            .frame(width: 200, height: 100)
    }
}
