// Created by Leopold Lemmermann on 31.03.23.

import SwiftUI

struct TabView<Tab: Tabbable>: View {
  @Binding var selection: Tab

  var body: some View {
    stack {
      GeometryReader { geo in
        ZStack {
          ForEach(allTabs, id: \.self) {
            $0.tab
              .offset(
                tabOffset(geoSize: geo.size, factor: allTabs.firstIndex(of: $0)! - allTabs.firstIndex(of: selection)!)
              )
          }
        }
      }

      TabBar(selection: $selection)
        .frame(maxWidth: displaySideTabbar ? 70 : nil, maxHeight: displaySideTabbar ? nil : 70)
        .padding(10)
    }
    .animation(.default, value: selection)
    .animation(.default, value: displaySideTabbar)
  }

  private var displaySideTabbar: Bool { vSize == .compact }
  @Environment(\.verticalSizeClass) private var vSize

  private var currentIndex: Int { allTabs.firstIndex(of: selection)! }
  private var previous: Tab? { currentIndex > 0 ? allTabs[currentIndex - 1] : nil }
  private var next: Tab? { (currentIndex < allTabs.count - 1) ? allTabs[currentIndex + 1] : nil }
  private var allTabs: [Tab] { Array(Tab.allCases) }

  @ViewBuilder
  private func stack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    if displaySideTabbar {
      HStack(content: content)
    } else {
      VStack(content: content)
    }
  }

  private func tabOffset(geoSize: CGSize, factor: Int) -> CGSize {
    CGSize(
      width: displaySideTabbar ? 0 : geoSize.width * Double(factor),
      height: displaySideTabbar ? geoSize.height * Double(factor) : 0
    )
  }
}

// MARK: - (PREVIEWS)

import ComposableArchitecture

struct TabView_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Example3Tab.dashboard) { binding in
      TabView<Example3Tab>(selection: binding)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      TabView<Example3Tab>(selection: binding)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Side Tabbar")
    }
  }
}
