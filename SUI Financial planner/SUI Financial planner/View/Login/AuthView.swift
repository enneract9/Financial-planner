import SwiftUI

struct AuthView: View {
    
    @Environment(\.locale) var locale
    @State var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Spacer()

            signInWithButton(
                text: "auth.signInWithGoogle".localized(locale.identifier)
            ) {
                withAnimation {
                    authViewModel.signIn()
                }
            }
            
            Spacer()
        }
    }

    private func signInWithButton(
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
