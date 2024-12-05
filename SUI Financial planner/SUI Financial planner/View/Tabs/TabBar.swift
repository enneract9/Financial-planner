import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case account
    
    var image: String {
        switch self {
        case .home:
            return "house"
        case .account:
            return "person"
        }
    }
    
    var selectedImage: String {
        return image + ".fill"
    }
}

struct TabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                Image(systemName: tab == selectedTab ? tab.selectedImage : tab.image)
                    .scaleEffect(tab == selectedTab ? 1.1 : 1.0)
                    .foregroundStyle(Color.assetsIcon)
                    .font(.system(size: 22))
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.1)) {
                            selectedTab = tab
                        }
                    }
                Spacer()
            }
        }
        .frame(height: 60)
        .background(.ultraThinMaterial)
        .clipShape(.capsule)
        .padding()
        .shadow(color: .gray.opacity(0.8), radius: 4)
    }
}

#Preview {
    TabBar(selectedTab: .constant(.home))
}
