import SwiftUI

fileprivate struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct AddTransactionView: View {

    // MARK: - Properties

    @Environment(\.locale) var locale
    @Environment(\.dismiss) private var dismiss
    @State private var description: String = ""
    @State private var amount: Double? = nil
    @State private var category: Category
    @State private var date: Date = Date()
    @State private var isExpense: Bool
    @State private var shouldAnimateError = false
    private let onTapSave: (Transaction) -> Void

    init(
        isExpense: Bool,
        onTapSave: @escaping (Transaction) -> Void
    ) {
        self.isExpense = isExpense
        self.onTapSave = onTapSave
        self.category = isExpense ? Category.expenses[0] : Category.incomes[0]
    }

    @State private var sheetHeight: CGFloat = .zero

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center) {
            topBar()
            descriptionField()
            amountField()
                .overlay(
                    (shouldAnimateError ? Color.red.opacity(0.4) : .clear)
                        .allowsHitTesting(false)
                        .clipShape(.rect(cornerRadius: 16))
                )
            CategoryHGrid(
                categories: isExpense ? Category.expenses : Category.incomes,
                selectedCategory: $category
            )
            HStack {
                addButton()
                datePicker()
            }
        }
        .padding()
        .overlay {
            GeometryReader { geometry in
                Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            sheetHeight = newHeight
        }
        .presentationDetents([.height(sheetHeight)])
        .presentationBackground(
            LinearGradient(
                gradient: Gradient(colors: [.assetsBackground, .gray]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .presentationCornerRadius(20)
    }

    // MARK: - Subviews

    private func topBar() -> some View {
        HStack {
            Text(
                isExpense
                ? "addTransactionView.title.expense".localized(locale.identifier)
                    : "addTransactionView.title.income".localized(locale.identifier)
            )
            .font(.title2)
            .bold()
            Spacer()
            dismissButton()
        }
        .padding(.bottom)
    }
    
    private func dismissButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.assetsText)
                .font(.system(size: 24))
        }
    }
    
    private func addButton() -> some View {
        Button {
            addAction()
        } label: {
            Text("save".localized(locale.identifier))
                .padding()
                .frame(minWidth: 100)
                .background(Color.systemBackground)
                .clipShape(.rect(cornerRadius: 16))
                .tint(.assetsText)
        }
        .buttonStyle(.plain)
    }
    
    private func datePicker() -> some View {
        DatePicker(
            selection: $date,
            in: ...Date.now,
            displayedComponents: .date) {}
    }
    
    private func descriptionField() -> some View {
        TextField(text: $description) {
            Text("addTransactionView.description.placeholder".localized(locale.identifier))
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(.rect(cornerRadius: 16))
    }
    
    private func amountField() -> some View {
        TextField(
            value: $amount,
            format: .number
        ) {
            Text("addTransactionView.sum.placeholder".localized(locale.identifier))
        }
        .padding()
        .foregroundStyle(Color.primary)
        .background(Color.systemBackground)
        .clipShape(.rect(cornerRadius: 16))
    }

    private func addAction() {
        guard let amount = amount, amount > 0 else {
            let animation = Animation.easeInOut(duration: 1).repeatCount(1, autoreverses: true)
            withAnimation(animation) {
                self.shouldAnimateError.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(animation) {
                    self.shouldAnimateError.toggle()
                }
            }
            return
        }

        let newTransaction = Transaction(
            description: description,
            amount: amount,
            category: category,
            isExpense: isExpense,
            date: date
        )
        onTapSave(newTransaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView(
        isExpense: false,
        onTapSave: { _ in }
    )
}
