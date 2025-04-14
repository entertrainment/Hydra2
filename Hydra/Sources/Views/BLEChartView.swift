import SwiftUI
import Charts

struct BLEChartView: View {
    let rssiData: [RSSIPoint]
    
    var body: some View {
        Chart {
            ForEach(rssiData) { point in
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("RSSI", point.value)
                )
            }
        }
        .frame(height: 80)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4))
        }
    }
}
