import SwiftUI

struct ContentView: View {
    @ObservedObject var transactionListViewModel: TransactionListViewModel
    @ObservedObject var loginViewModel: AuthViewModel

    @State private var selectedTab: Tab = .home

    var body: some View {
        if loginViewModel.isUserLoggedIn {
            Content()
        } else {
            AuthView(authViewModel: loginViewModel)
        }
    }

    @ViewBuilder
    private func Content() -> some View {
        TabView(selection: $selectedTab) {
            MainView(transactionListViewModel: transactionListViewModel)
                .tag(Tab.home)
            AccountView(
                loginViewModel: loginViewModel,
                transactionListViewModel: transactionListViewModel
            )
                .tag(Tab.account)
        }
        .overlay(alignment: .bottom) {
            TabBar(selectedTab: $selectedTab)
                .frame(width: 200)
        }
    }
}

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
//    let loginViewModel = LoginViewModel()
//
//    return ContentView(transactions: $transactions)
//        .environmentObject(loginViewModel)
//}
