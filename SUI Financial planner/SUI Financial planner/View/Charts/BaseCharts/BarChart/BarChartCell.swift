import SwiftUI

public struct BarChartCell : View {
    var value: Double

    var maxValue: Double
    var minValue: Double

    // для анимации
    var index: Int = 0

    // для ширины столбца
    var width: Float
    var numberOfDataPoints: Int
    var cellWidth: Double {
        return Double(width)/(Double(numberOfDataPoints) * 1.5)
    }

    // цвета
    var accentColor: Color
    var gradient: GradientColor?

    // высоты
    @State var topScaleValue: Double = 0
    @State var scaleValue: Double = 0
    @State var bottomScaleValue: Double = 0

    @Binding var touchLocation: CGFloat
    public var body: some View {

        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        gradient: gradient?.getGradient() ?? GradientColor(start:accentColor, end: accentColor).getGradient(),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .opacity(value < 0 ? 0.5 : 1)
                )
                .frame(height: proxy.size.height * scaleValue)
                .animation(
                    Animation.spring().delay(
                        self.touchLocation < 0 ? (Double(self.index) * 0.04) : 0
                    ),
                    value: touchLocation
                )
                .padding(.top, proxy.size.height * topScaleValue)
                .padding(.bottom, proxy.size.height * bottomScaleValue)
        }
        .frame(width: cellWidth)
        .onAppear() {
            let max = abs(maxValue)
            let min = abs(minValue)
            let val = abs(value)
            let dist = max + min

            guard dist > 0 else {
                return
            }

            self.scaleValue = val / dist
            if value >= 0 {
                self.bottomScaleValue = min / dist
                self.topScaleValue = (max - val) / dist
            } else {
                self.bottomScaleValue = (min - val) / dist
                self.topScaleValue = max / dist
            }
        }
    }
}

#Preview {
    BarChartCell(
        value: 55,
        maxValue: 100,
        minValue: -100,
        width: 320,
        numberOfDataPoints: 12,
        accentColor: Colors.OrangeStart,
        gradient: nil,
        touchLocation: .constant(-1)
    )
}
