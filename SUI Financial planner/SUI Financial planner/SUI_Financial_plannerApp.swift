import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

    FirebaseApp.configure()
    return true
  }
}

@main
struct SUI_Financial_plannerApp: App {
    @StateObject var languageSettings = AppSettings.shared
    @StateObject var transactionListViewModel = TransactionListViewModel()
    @StateObject var loginViewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(
                transactionListViewModel: transactionListViewModel,
                loginViewModel: loginViewModel
            )
            .environment(languageSettings)
            .environment(\.locale, Locale(identifier: languageSettings.languageCode))
        }
    }
}
