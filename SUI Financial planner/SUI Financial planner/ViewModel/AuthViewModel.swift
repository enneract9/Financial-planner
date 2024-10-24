import Firebase
import FirebaseAuth
import GoogleSignIn

final class AuthViewModel: ObservableObject {

    @Published private(set) var isUserLoggedIn: Bool
    @Published private(set) var currentUser: GIDGoogleUser?

    private let gidSignIn = GIDSignIn.sharedInstance

    init() {
        self.isUserLoggedIn = gidSignIn.hasPreviousSignIn()

        if isUserLoggedIn {
            gidSignIn.restorePreviousSignIn { [weak self] user, error in
                self?.authenticate(user, with: error)
            }
        }
    }

    func signIn() {
        if gidSignIn.hasPreviousSignIn() {
            gidSignIn.restorePreviousSignIn { [weak self] user, error in
                self?.authenticate(user, with: error)
            }
        }

        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            let viewController = try UIApplication.getRootViewController()
            
            gidSignIn.configuration = config
            gidSignIn.signIn(withPresenting: viewController) { [weak self] result, error in
                self?.authenticate(result?.user, with: error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func authenticate(_ user: GIDGoogleUser?, with error: Error?) {
      if let error = error {
        print(error.localizedDescription)
        return
      }

        guard let idToken = user?.idToken?.tokenString, let accessToken = user?.accessToken.tokenString else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
            print(error.localizedDescription)
        } else {
            self.isUserLoggedIn = true
            self.currentUser = user
        }
      }
    }

    func signOut() {
        gidSignIn.signOut()
        isUserLoggedIn = false
        currentUser = nil
    }
}
