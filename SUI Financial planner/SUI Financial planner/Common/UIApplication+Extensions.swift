import UIKit

extension UIApplication {
    static func getRootViewController() throws -> UIViewController {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        guard let viewController = window?.rootViewController else {
            fatalError()
        }
        return viewController
    }
}
