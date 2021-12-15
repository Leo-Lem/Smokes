//
//  CustomPicker.swift
//
//
//  Created by Leopold Lemmermann on 11.11.21.
//

import SwiftUI
import MyDates
import MyLayout

public struct CustomPicker: View {
    @Binding private var selection: AvgTimespanType
    private let height: CGFloat
    
    public var body: some View {
        Picker(selection: $selection, label: Text("")) {
            ForEach(AvgTimespanType.allCases, id:\.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .customBackground()
        .padding(.horizontal)
    }
    
    init(_ selection: Binding<AvgTimespanType>, height: CGFloat = LayoutDefaults().rowHeight) {
        self._selection = selection
        self.height = height
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(.constant(.at))
    }
}
