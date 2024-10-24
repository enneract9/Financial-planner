import SwiftUI

struct SwitchView: View {

    @Environment(\.locale) var locale
    @Binding var showsExpenses: Bool

    var body: some View {
        HStack(spacing: 6) {
            SwitchLabel(
                "expenses".localized(locale.identifier),
                isSelected: showsExpenses
            )
                .onTapGesture {
                    withAnimation {
                        showsExpenses = true
                    }
                }

            SwitchLabel(
                "incomes".localized(locale.identifier),
                isSelected: !showsExpenses
            )
                .onTapGesture {
                    withAnimation {
                        showsExpenses = false
                    }
                }
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.systemBackground)
        }
    }

    private func SwitchLabel(_ text: String, isSelected: Bool) -> some View {
        HStack {
            Spacer()
            Text(text)
                .foregroundStyle(.primary)
                .padding(.vertical, 6)
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.assetsIcon : .clear)
                .stroke(
                    .secondary,
                    style: StrokeStyle(
                        lineWidth: isSelected ? 0 : 1,
                        dash: [5]
                    )
                )
        }
    }
}

#Preview {
    @State var flag = false

    return SwitchView(showsExpenses: $flag)
}
