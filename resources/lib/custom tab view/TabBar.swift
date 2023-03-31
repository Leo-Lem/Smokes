// Created by Leopold Lemmermann on 31.03.23.

import SwiftUI

struct TabBar<Tab: Tabbable>: View {
  @Binding var selection: Tab

  var body: some View {
    stack {
      ForEach(Array(Tab.allCases), id: \.self) { tab in
        Button { selection = tab } label: {
          tab.tabItem
            .frame(maxWidth: tabItemSize?.width, maxHeight: tabItemSize?.height)
            .background {
              if selection == tab {
                Color.accentColor
                  .matchedGeometryEffect(id: "selectedItem", in: selectedItem)
                  .offset(tabItemOffset)
                  .gesture(tabItemDragGesture)
              }

              GeometryReader { geo in
                Color.clear.preference(key: TabItemSizePreferenceKey.self, value: geo.size)
              }
            }
        }
        .zIndex(selection == tab ? 0 : 1)
      }
    }
    .background(.regularMaterial)
    .cornerRadius(100)
    .animation(.default, value: selection)
    .animation(.default, value: displaySide)
    .animation(.default, value: tabItemOffset)
    .onPreferenceChange(TabItemSizePreferenceKey.self) { tabItemSize = $0 }
  }

  @State private var tabItemSize: CGSize?

  private var displaySide: Bool { vSize == .compact }
  @Namespace private var selectedItem
  @Environment(\.verticalSizeClass) private var vSize
  
  private var currentIndex: Int { allTabs.firstIndex(of: selection)! }
  private var previous: Tab? { currentIndex > 0 ? allTabs[currentIndex - 1] : nil }
  private var next: Tab? { (currentIndex < allTabs.count - 1) ? allTabs[currentIndex + 1] : nil }
  private var allTabs: [Tab] { Array(Tab.allCases) }
  
  @State private var tabItemOffset: CGSize = .zero
  private var tabItemDragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        if displaySide {
          tabItemOffset.height = value.translation.height
        } else {
          tabItemOffset.width = value.translation.width
        }
      }
      .onEnded { value in
        tabItemOffset = .zero
        if displaySide {
          let index = currentIndex + Int(round(value.translation.height / (tabItemSize?.height ?? 1)))
          if allTabs.indices.contains(index) { selection = allTabs[index] }
        } else {
          let index = currentIndex + Int(round(value.translation.width / (tabItemSize?.width ?? 1)))
          if allTabs.indices.contains(index) { selection = allTabs[index] }
        }
      }
  }

  @ViewBuilder
  private func stack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    if displaySide {
      VStack(content: content)
    } else {
      HStack(content: content)
    }
  }
}

private extension TabBar {
  struct TabItemSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
      value = CGSize(width: max(value.width, nextValue().width), height: max(value.height, nextValue().height))
    }
  }
}

// MARK: - (PREVIEWS)

struct TabBar_Previews: PreviewProvider {
  static var previews: some View {
    Binding.Preview(Example5Tab.dashboard) { binding in
      TabBar<Example5Tab>(selection: binding)
        .environment(\.verticalSizeClass, .regular)
        .previewDisplayName("Regular")

      TabBar<Example5Tab>(selection: binding)
        .environment(\.verticalSizeClass, .compact)
        .previewDisplayName("Side Tabbar")
    }
  }
}
