import SwiftUI

public struct AnnotatedPieChartView : View {
    @State public var data: [(value: Double, color: Color, name: String?)]
    public var title: String
    public var annotation: String
    public var cornerImage: Image
    public var placeholder: String
    public var style: ChartStyle
    public var dropShadow: Bool
    public var valueSpecifier: String

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State private var showValue = false
    @State private var currentName: String? = nil
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }

    public init(
        data: [(value: Double, color: Color, name: String?)],
        title: String,
        annotation: String,
        cornerImage: Image,
        placeholder: String,
        style: ChartStyle = Styles.pieChartStyleOne,
        dropShadow: Bool = false,
        valueSpecifier: String = "%.2f"
    ){
        self.data = data
        self.title = title
        self.annotation = annotation
        self.cornerImage = cornerImage
        self.placeholder = placeholder
        self.style = style
        self.dropShadow = dropShadow
        self.valueSpecifier = valueSpecifier
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Title()
                Spacer()
                CornerImage()
            }
            PieChartRow(
                data: data,
                backgroundColor: style.backgroundColor,
                showValue: $showValue,
                currentValue: $currentValue,
                currentName: $currentName
            )
//            .foregroundColor(self.style.accentColor)
            Legend()
        }
        .overlay {
            if data.isEmpty { Placeholder() }
        }
        .background(
            Background()
        )
        .frame(width: 382, height: ChartForm.extraLarge.height)
    }

    private func Title() -> some View {
        let text = showValue
            ? String(format: self.valueSpecifier, self.currentValue)
            : self.title

        return Text(text)
            .font(.title)
            .lineLimit(1)
            .foregroundStyle(.primary)
            .padding(.leading)
            .padding(.top)
    }

    private func CornerImage() -> some View {
        self.cornerImage
            .imageScale(.large)
            .foregroundColor(
                self.colorScheme == .dark 
                    ? self.style.darkModeStyle?.legendTextColor
                    : self.style.legendTextColor
            )
            .padding(.top)
            .padding(.trailing)
    }

    private func Legend() -> some View {
        let text = showValue
            ? self.currentName ?? ""
            : self.annotation

        return Text(text)
            .font(.headline)
            .foregroundStyle(self.style.legendTextColor)
            .padding(.leading)
            .padding(.bottom)
    }

    private func Placeholder() -> some View {
        Text(placeholder)
            .foregroundStyle(self.style.legendTextColor)
    }

    private func Background() -> some View {
        Rectangle()
            .fill(Color.systemBackground)
            .cornerRadius(20)
            .shadow(
                color: self.dropShadow ? self.style.dropShadowColor : .clear,
                radius: 12
            )
    }
}

#Preview {
    let data: [(Double, Color, String?)] = [
        (1, .red, "R"),
        (3, .green, "G"),
        (2, .blue, "B")
    ]

    return AnnotatedPieChartView(
        data: data,
        title: "1233",
        annotation: "Расходы", 
        cornerImage: CurrencyCode.rub.image, 
        placeholder: "Нет данных",
        style: Styles.barChartStyleNeonBlue,
        dropShadow: true
    )
}
