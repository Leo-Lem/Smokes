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
  let enabledOptions: [Option]
  let menuAlignment: Alignment
  let content: (Option) -> Content
  
  var body: some View {
    Widget { content(selection) }
      .overlay(alignment: menuAlignment) {
        Menu {
          ForEach(enabledOptions, id: \.self) { selection in
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
  
  init(
    selection: Binding<Option>,
    enabled: [Option] = Array(Option.allCases),
    menuAlignment: Alignment = .topLeading,
    @ViewBuilder content: @escaping (Option) -> Content
  ) {
    _selection = selection
    enabledOptions = enabled
    self.menuAlignment = menuAlignment
    self.content = content
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
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
#endif
