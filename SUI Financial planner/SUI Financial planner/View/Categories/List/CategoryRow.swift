import SwiftUI
import SwiftUIFontIcon

struct CategoryRow: View {
    @Environment(\.locale) var locale
    @State var category: Category
    @State var amount: Double
    @State var count: Int
    @State var currencyCode: CurrencyCode

    var body: some View {
        HStack() {
            Icon()
            Titles()
            Spacer(minLength: 20)
            Amount()
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.systemBackground)
        }
    }

    private func Icon() -> some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(category.color.opacity(0.5))
            .opacity(0.3)
            .frame(width: 44, height: 44)
            .overlay {
                FontIcon.text(
                    .awesome5Solid(code: category.iconCode),
                    fontsize: 24,
                    color: category.color
                )
            }
            .padding(.trailing, 8)

    }

    private func Titles() -> some View{
        VStack(alignment: .leading, spacing: 6) {
            Text(category.localized(locale.identifier))
                .font(.subheadline)
                .bold()
                .lineLimit(2)

            Text(String(format: "operations".localized(locale.identifier), count))
                .font(.footnote)
                .foregroundStyle(Color.secondary)
        }
    }

    private func Amount() -> some View {
        Text(amount, format: .currency(code: currencyCode.rawValue))
            .bold()
            .foregroundStyle(
                Color.primary
            )
            .lineLimit(1)
            .padding(.trailing, 4)
    }
}

#Preview {
    Rectangle()
        .fill(
            LinearGradient(
                gradient: Gradient(colors: [.assetsBackground, .gray]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
        .overlay {
            CategoryRow(
                category: .car,
                amount: 123.134,
                count: 21,
                currencyCode: .rub
            )
            .padding()
        }
}
