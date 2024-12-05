import SwiftUI

struct CategoryHGrid: View {
    /// Please ensure that categories are all unique
    let categories: [Category]
    @Binding var selectedCategory: Category

    var body: some View {
        let rows = [
            GridItem(.fixed(88))
        ]
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(categories, id: \.rawValue) { category in
                    CategoryCell(
                        isSelected: .init(get: { category == selectedCategory },
                                          set: { value in }
                                         ),
                        category: category
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeInOut(duration: 0.15)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(.rect(cornerRadius: 20))
//            .shadow(color: .gray, radius: 10)
        }
        .scrollClipDisabled()
        .scrollIndicators(.never)
    }
}

#Preview {
    @State var selectedCategory: Category = .car
    return CategoryHGrid(categories: Category.expenses, selectedCategory: $selectedCategory)
}
