import Foundation
import Collections
import FirebaseFirestore

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = Array<(date: Date, amount: Double)>
 
@MainActor
final class TransactionListViewModel: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []

    private let firestore = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    // MARK: - Lifecycle

    init() {
        subscribe()
    }

    deinit {
        Task {
            await unsubscribe()
        }
    }

    // MARK: - Firebase

    private func subscribe() {
        guard listenerRegistration == nil else {
            return
        }

        let reference = firestore.referenceToTransactions()

        listenerRegistration = reference.addSnapshotListener { [weak self] querySnaphot, error in
            guard let documents = querySnaphot?.documents else {
                print("No documents")
                return
            }

            self?.objectWillChange.send()

            self?.transactions = documents.compactMap {
                do {
                    return try $0.data(as: Transaction.self)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }.sorted(by: { $0.date > $1.date } )
        }
    }

    private func unsubscribe() {
        guard listenerRegistration == nil else { return }
        listenerRegistration?.remove()
        listenerRegistration = nil
    }

    func add(_ transaction: Transaction) {
        self.objectWillChange.send()
        let reference = firestore.referenceToTransactions()
        do {
            try reference.document(transaction.id).setData(from: transaction)
        } catch {
            print(error.localizedDescription)
        }
    }

    func remove(at indexSet: IndexSet) {
        self.objectWillChange.send()
        let reference = firestore.referenceToTransactions()
        let IDs = indexSet.map { transactions[$0].id }

        IDs.forEach { id in
            reference.document(id).delete()
        }
    }

    func remove(_ ids: [String]) {
        self.objectWillChange.send()
        let reference = firestore.referenceToTransactions()

        ids.forEach { id in
            reference.document(id).delete()
        }
    }
}
