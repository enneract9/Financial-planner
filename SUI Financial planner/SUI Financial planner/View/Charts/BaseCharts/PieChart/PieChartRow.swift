import SwiftUI

public struct PieChartRow : View {
    typealias Data = [(value: Double, color: Color, name: String?)]

    var data: Data
    var backgroundColor: Color
    var slices: [PieSlice] {
        var tempSlices: [PieSlice] = []
        var lastEndDegree = 0.0
        let maxValue = data.reduce(0, { $0 + $1.value })

        for slice in data {
            let normalized = slice.value / maxValue
            let startDegree = lastEndDegree
            let endDegree = lastEndDegree + (normalized * 360)
            lastEndDegree = endDegree
            tempSlices.append(
                PieSlice(
                    startDeg: startDegree,
                    endDeg: endDegree,
                    value: slice.value,
                    normalizedValue: normalized,
                    color: slice.color,
                    name: slice.name
                )
            )
        }
        return tempSlices
    }
    
    @Binding var showValue: Bool
    @Binding var currentValue: Double
    @Binding var currentName: String?

    @State private var currentTouchedIndex = -1 {
        didSet {
            if oldValue != currentTouchedIndex {
                showValue = currentTouchedIndex != -1
                currentValue = showValue ? slices[currentTouchedIndex].value : 0
                currentName = showValue ? slices[currentTouchedIndex].name : nil
            }
        }
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<self.slices.count) { i in
                    PieChartCell(
                        rect: geometry.frame(in: .local),
                        startDeg: self.slices[i].startDeg,
                        endDeg: self.slices[i].endDeg,
                        index: i,
                        backgroundColor: self.backgroundColor,
                        accentColor: self.slices[i].color
                    )
                        .scaleEffect(self.currentTouchedIndex == i ? 1.1 : 1)
                        .animation(.spring(), value: currentTouchedIndex)
                }
            }

            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            let rect = geometry.frame(in: .local)
                            let isTouchInPie = isPointInCircle(point: value.location, circleRect: rect)
                            if isTouchInPie {
                                let touchDegree = degree(for: value.location, inCircleRect: rect)
                                self.currentTouchedIndex = self.slices.firstIndex(where: { $0.startDeg < touchDegree && $0.endDeg > touchDegree }) ?? -1
                            } else {
                                self.currentTouchedIndex = -1
                            }
                        })
                        .onEnded({ value in
                            self.currentTouchedIndex = -1
                        }))
        }
    }
}

#Preview {
    let data: PieChartRow.Data = [(1, .red, "A"), (3, .green, "B"), (2, .mint, "C")]
    @State var showValue: Bool = false
    @State var currentValue: Double = 0.0
    @State var currentName: String? = nil

    return PieChartRow(data: data, backgroundColor: .clear, showValue: $showValue, currentValue: $currentValue, currentName: $currentName).padding()
}
