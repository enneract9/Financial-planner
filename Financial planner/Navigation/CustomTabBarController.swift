import UIKit

final class CustomTabBarController: UITabBarController {
    
    // MARK: - Private properties
    private let customTabBar = CustomTabBar()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(customTabBar, forKey: "tabBar")
        setupTabBarItems()
    }
    
    // MARK: - Setup
    private func setupTabBarItems() {
        
        
    }
}
