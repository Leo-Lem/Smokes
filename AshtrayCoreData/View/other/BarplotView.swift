//
//  PlotView.swift
//  AshtraySwiftUI
//
//  Created by Leopold Lemmermann on 14.11.21.
//

import SwiftUI
import MyLayout

struct BarplotView: View {
    let data: [Int], labels: [String]
    let spacing: CGFloat = 10
    private var minimum: Double { 0 }
    private var maximum: Double { Double((data.max() ?? 1)) * 1.15 }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    BarStack(data: data, min: minimum, max: maximum, spacing: spacing)
                    BarChartAxes().stroke(Color.primary, lineWidth: 2)
                }
                LabelStack(labels: labels, spacing: spacing)
            }
            .frame(maxWidth: geo.size.width*0.9, maxHeight: geo.size.height*0.9)
            .padding()
        }
    }
}

extension BarplotView {
    struct BarStack: View {
        let data: [Int], min: Double, max: Double, spacing: CGFloat
        
        var body: some View {
            GeometryReader { geo in
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(0..<data.count) { index in
                        ZStack(alignment: .bottom) {
                            Text("\(data[index])")
                                .minimumScaleFactor(0.1)
                                .offset(y: -(Double(data[index])-min)/(max-min) * geo.size.height)
                            Color.secondaryAlpha.clipShape(BarPath(entry: data[index], max: max, min: min))
                        }
                    }
                }.padding(.horizontal, spacing)
            }
        }
        
        struct BarPath: Shape {
            let entry: Int, max: Double, min: Double
            
            func path(in rect: CGRect) -> Path {
                guard min != max else { return Path() }
                let height = CGFloat((Double(entry)-min)/(max-min)) * rect.height
                let bar = CGRect(x: rect.minX, y: rect.maxY - (rect.minY + height), width: rect.width, height: height)
                
                return RoundedRectangle(cornerRadius: 5).path(in: bar)
            }
        }
    }
}

extension BarplotView {
    struct LabelStack: View {
        let labels: [String], spacing: CGFloat
        
        var body: some View {
            HStack(alignment: .center, spacing: spacing) {
                ForEach(labels, id:\.self) { label in
                    Text(label).frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                }
            }
            .padding(.horizontal, spacing)
        }
    }
}

extension BarplotView {
    struct BarChartAxes: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            
            return path
        }
    }
}

struct BarplotView_Previews: PreviewProvider {
    static var previews: some View {
        BarplotView(data: [1, 2, 5, 1, 10, 2, 5, 1, 10], labels: ["day 1", "day 2", "day 3", "day 4", "day 5", "day 2", "day 3", "day 4", "day 5"])
    }
}
