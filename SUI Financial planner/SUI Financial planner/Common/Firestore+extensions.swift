import FirebaseFirestore
import Firebase

extension Firestore {
    public func referenceToTransactions() -> CollectionReference {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No firebase app")
        }
        return self.collection("users").document(clientID).collection("transactions")
    }
}
