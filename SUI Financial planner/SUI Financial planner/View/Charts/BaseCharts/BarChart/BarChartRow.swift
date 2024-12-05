import SwiftUI

public struct BarChartRow : View {
    var data: [Double]
    var accentColor: Color
    var gradient: GradientColor?
    
    var maxValue: Double {
        guard let max = data.max() else {
            return 1
        }
        return max != 0 ? max : 1
    }

    var minValue: Double {
        guard let min = data.min() else {
            return -1
        }
        return min != 0 ? min : -1
    }

    @Binding var touchLocation: CGFloat
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.data.count * 3)){
                ForEach(0..<self.data.count, id: \.self) { i in
                    BarChartCell(
                        value: self.data[i],
                        maxValue: maxValue,
                        minValue: minValue,
                        index: i,
                        width: Float(geometry.frame(in: .local).width - 22),
                        numberOfDataPoints: self.data.count,
                        accentColor: self.accentColor,
                        gradient: self.gradient,
                        touchLocation: self.$touchLocation
                    )
                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring(), value: touchLocation)
                }
            }
            .padding([.top, .leading, .trailing], 10)
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        return Double(self.data[index])/Double(self.maxValue)
    }
}

#Preview {
    BarChartRow(data: [8,23,54,32,12,37,7], accentColor: Colors.OrangeStart, touchLocation: .constant(-1))
}
