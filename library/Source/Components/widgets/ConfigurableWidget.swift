// Created by Leopold Lemmermann on 31.03.23.

import SwiftUI

public protocol ConfigurableWidgetOption: Hashable, CaseIterable {
  associatedtype Label: View
  @ViewBuilder var label: Label { get }
}

public extension ConfigurableWidgetOption where Self: RawRepresentable<String> {
  var label: some View { Text(description) }
  var description: LocalizedStringResource { LocalizedStringResource(stringLiteral: rawValue) }
}

// TODO: make the protocol unnecessary
public struct ConfigurableWidget<Option: ConfigurableWidgetOption, Content: View>: View {
  @Binding var selection: Option
  let enabledOptions: [Option]
  let menuAlignment: Alignment
  let content: (Option) -> Content

  public var body: some View {
    Widget {
      content(selection).padding()
    }
    .overlay(alignment: menuAlignment) {
      Menu {
        ForEach(enabledOptions, id: \.self) { selection in
          Button { self.selection = selection } label: { selection.label }
        }
      } label: {
        Label("configure", systemImage: "arrowtriangle.down.circle.fill")
          .imageScale(.large)
      }
      .padding(5)
      .labelStyle(.iconOnly)
    }
  }

  public init(
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

#Preview {
  enum AmountSelection: String, ConfigurableWidgetOption {
    case week, month, year
  }

  return Binding.Preview(AmountSelection.week) { binding in
    ConfigurableWidget(selection: binding) { selection in
        switch selection {
        case .week: Text("10")
        case .month: Text("190")
        case .year: Text("1000")
        }
    }
  }
}
