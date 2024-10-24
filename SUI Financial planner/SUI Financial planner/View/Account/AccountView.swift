import SwiftUI

struct AccountView: View {

    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.locale) var locale

    @ObservedObject var loginViewModel: AuthViewModel
    @ObservedObject var transactionListViewModel: TransactionListViewModel

    @State private var showsExpenses: Bool = false

    private var transactionsGroup: TransactionGroup {
        transactionListViewModel.transactions.makeTransactionGroupByDate(ascending: true)
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Title(
                        loginViewModel.currentUser?.profile?.name ?? "loading...",
                        imageUrl: loginViewModel.currentUser?.profile?.imageURL(withDimension: 32)
                    )

                    SwitchView(showsExpenses: $showsExpenses)
                        .padding(.horizontal)

                    TransactionsPieChart(
                        data: transactionsGroup,
                        currency: CurrencyCode(rawValue: appSettings.currencyCode) ?? .rub,
                        showsExpenses: showsExpenses
                    )

                    Spacer()
                }
            }
            .containerRelativeFrame([.horizontal, .vertical])
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.assetsBackground, .gray]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .toolbarBackground(.hidden, for: .tabBar)
            .toolbarBackground(.hidden, for: .automatic)
            .scrollIndicators(.never)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            appSettings.languageCode = appSettings.languageCode == "ru"
                                ? "en"
                                : "ru"
                        } label: {
                            Label(
                                "accountView.toolbar.language".localized(locale.identifier),
                                systemImage: "book.and.wrench"
                            )
                        }
                        Button {
                            appSettings.currencyCode = appSettings.currencyCode == "RUB"
                                ? "USD"
                                : "RUB"
                        } label: {
                            Label(
                                "accountView.toolbar.currency".localized(locale.identifier),
                                systemImage: "arrow.down.left.arrow.up.right.square"
                            )
                        }
                        Button {
                            loginViewModel.signOut()
                        } label: {
                            Label(
                                "accountView.toolbar.signOut".localized(locale.identifier),
                                systemImage: "person.fill.xmark"
                            )
                        }
                    } label: {
                        Image(systemName: "gearshape")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.assetsIcon, .primary)
                    }
                    .id(UUID())
                }
            }
        }
    }

    private func Title(_ text: String, imageUrl: URL? = nil) -> some View {
        HStack {
            AsyncImage(url: imageUrl) { phase in
                phase.image?
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(.circle)
            }
            Text(text)
                .font(.title)
                .bold()
                .padding(.vertical)
            Spacer()
        }
        .padding(.leading)
        .padding(.bottom, 8)
    }

    private func signOutWithButton(
        text: String,
        _ action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
                .padding()
                .background(.black)
                .cornerRadius(12)
                .padding()
        }
    }
}

#Preview {
    @StateObject var transactionListViewModel = TransactionListViewModel()
    @StateObject var loginViewModel = AuthViewModel()

    return AccountView(
        loginViewModel: loginViewModel,
        transactionListViewModel: transactionListViewModel
    )
}
