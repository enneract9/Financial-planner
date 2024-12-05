import SwiftUI
import SwiftUIFontIcon

struct CategoryCell: View {
    @Environment(\.locale) var locale
    @Binding var isSelected: Bool
    var category: Category
    
    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    Color.assetsIcon,
                    lineWidth: isSelected ? 3 : 0
                )
                .fill(Color.assetsIcon.opacity(0.3))
                .frame(width: 64, height: 64)
                .overlay {
                    FontIcon.text(
                        .awesome5Solid(code: category.iconCode),
                        fontsize: 32,
                        color: Color.assetsIcon
                    )
                }
            
            Text(category.localized(locale.identifier))
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
        }
        .frame(width: 88)
    }
    
    
}

#Preview {
    CategoryCell(
        isSelected: .constant(true),
        category: .publicTransportation
    )
}
