import SwiftUI

public struct PieChartView : View {
    public var data: [(value: Double, color: Color, name: String?)]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    
    @State private var showValue = false
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }
    @State private var currentName: String? = nil

    public init(
        data: [Double],
        title: String,
        legend: String? = nil,
        style: ChartStyle = Styles.pieChartStyleOne,
        form: CGSize? = ChartForm.medium,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f"
    ){
        self.data = data.map { ($0, style.accentColor, nil) }
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }

    public init(
        data: [(value: Double, color: Color, name: String?)],
        title: String,
        legend: String? = nil,
        style: ChartStyle = Styles.pieChartStyleOne,
        form: CGSize? = ChartForm.medium,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f"
    ){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }

    public var body: some View {
        ZStack{
            Rectangle()
                .fill(self.style.backgroundColor)
                .cornerRadius(20)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 12 : 0)
            VStack(alignment: .leading) {
                HStack {
                    if(!showValue){
                        Text(self.title)
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }else{
                        Text("\(self.currentValue, specifier: self.valueSpecifier)")
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }
                }.padding()

                PieChartRow(
                    data: data,
                    backgroundColor: style.backgroundColor,
                    showValue: $showValue,
                    currentValue: $currentValue, 
                    currentName: $currentName
                )
                .foregroundColor(self.style.accentColor)
                .padding(self.legend != nil ? 0 : 12)
                .offset(y: self.legend != nil ? 0 : -10)

                if(self.legend != nil) {
                    Text(self.legend!)
                        .font(.headline)
                        .foregroundColor(self.style.legendTextColor)
                        .padding()
                }
                
            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#Preview {
    let data: [(Double, Color, String?)] = [(1, .red, nil), (3, .green, nil), (2, .mint, nil)]

    return PieChartView(data: data, title: "Title", legend: "Legend")
}
