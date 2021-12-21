//
//  CustomPicker.swift
//
//
//  Created by Leopold Lemmermann on 11.11.21.
//

import SwiftUI
import MyLayout
import MyOthers

public struct CustomPicker: View {
    @Binding private var selection: AverageView.ViewModel.Timespan
    private let height: CGFloat
    
    public var body: some View {
        Picker(selection: $selection, label: Text("")) {
            ForEach(AverageView.ViewModel.Timespan.allCases, id:\.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    init(_ selection: Binding<AverageView.ViewModel.Timespan>,
         height: CGFloat = LayoutDefaults.rowHeight) {
        self._selection = selection
        self.height = height
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(.constant(.alltime))
    }
}
