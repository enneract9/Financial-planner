import SwiftUI

class AppSettings: ObservableObject, Observable {

    static let shared = AppSettings()

    @Published var languageCode: String {
        willSet {
            if newValue != languageCode {
                UserDefaults.standard.setValue(newValue, forKey: "language")
            }
        }
    }

    @Published var currencyCode: String {
        willSet {
            if newValue != languageCode {
                UserDefaults.standard.setValue(newValue, forKey: "currency")
            }
        }
    }

    private init() {
        self.languageCode = UserDefaults.standard.string(forKey: "language") ?? "ru"
        self.currencyCode = UserDefaults.standard.string(forKey: "currency") ?? "RUB"
    }
}

extension String {
    func localized(_ languageCode: String) -> Self {
        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return NSLocalizedString(
            self,
            tableName: nil,
            bundle: bundle,
            comment: ""
        )
    }
}
