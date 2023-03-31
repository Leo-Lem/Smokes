// Created by Leopold Lemmermann on 31.03.23.

import SwiftUI

protocol ConfigurableWidgetOption: Hashable, CaseIterable {
  associatedtype Label: View
  @ViewBuilder var label: Label { get }
}

extension ConfigurableWidgetOption where Self: RawRepresentable<String> {
  var label: some View { Text(description) }
  var description: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct ConfigurableWidget<Option: ConfigurableWidgetOption, Content: View>: View {
  @Binding var selection: Option
  @ViewBuilder let content: (Option) -> Content
  
  var body: some View {
    Widget { content(selection) }
      .overlay(alignment: .topLeading) {
        Menu {
          ForEach(Array(Option.allCases), id: \.self) { selection in
            Button { self.selection = selection } label: { selection.label }
          }
        } label: {
          Label("CONFIGURE", systemImage: "arrowtriangle.down.circle.fill")
            .imageScale(.large)
        }
        .padding(10)
        .labelStyle(.iconOnly)
      }
  }
}

// MARK: - (PREVIEWS)

struct ConfigurableWidget_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(AmountSelection.week) { binding in
      ConfigurableWidget(selection: binding) { selection in
        switch selection {
        case .week: Text("10")
        case .month: Text("190")
        case .year: Text("1000")
        }
      }
    }
  }
}

enum AmountSelection: String, ConfigurableWidgetOption {
  case week, month, year
  var label: some View { Text(rawValue) }
}
