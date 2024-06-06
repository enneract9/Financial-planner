import UIKit

final class TabBarActionButton: UIButton {
    
    // MARK: - TabBarActionButtonType
    enum TabBarActionButtonType {
        case positive
        case negative
        
        var image: UIImage? {
            switch self {
            case .positive:
                UIImage(systemName: "plus")
            case .negative:
                UIImage(systemName: "minus")
            }
        }
        
        var color: UIColor {
            switch self {
            case .positive:
                UIColor.systemGreen
            case .negative:
                UIColor.systemRed
            }
        }
    }
    
    // MARK: - Public properties
    let type: TabBarActionButtonType
    
    // MARK: - Overriden functions
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 4
    }
    
    // MARK: - Initialization
    init(type: TabBarActionButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configure() {
        setImage(type.image, for: .normal)
        tintColor = .white
        backgroundColor = type.color
        layer.shadowColor = type.color.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
