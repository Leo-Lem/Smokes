//  Created by Leopold Lemmermann on 20.01.22.

import MyCustomUI
import SwiftUI

struct AshtrayView: View {
  var body: some View {
    VStack {
      TitleBarView(selectedOverlay: $currentOverlay)
        .font(_defaultFont, size: 25)
        .background(.bar)

      TabView(selection: $currentPage) {
        ForEach(Page.allCases, id: \.self) { page in
          page.view()
            .tabItem { Label(page.title, systemImage: page.symbol) }
            .tag(page)
        }
        .padding(.bottom, 50)
      }
      .tabViewStyle(.page)
      .labelStyle(.iconOnly)
    }
    .backgroundImage("background", opacity: 1)
    .overlay {
      ZStack {
        if currentOverlay != .none {
          Color.black.opacity(0.8).ignoresSafeArea()
            .onTapGesture { currentOverlay = .none }

          Group {
            if currentOverlay == .pref { PrefView() }
            else if currentOverlay == .info { InfoView() }
          }
          .transition(.move(edge: .top))
        }
      }
      .animation(currentOverlay)
    }
    .foregroundColor(.primary)
  }

  @State private var currentOverlay: Overlay = .none
  @State private var currentPage: Page = .main

  enum Overlay { case none, pref, info }
}

extension AshtrayView {
  enum Page: CaseIterable {
    case hist, main, stat
    
    @ViewBuilder func view() -> some View {
      switch self {
      case .main: MainView()
      case .stat: StatView()
      case .hist: HistView()
      }
    }
    
    var title: LocalizedStringKey {
      switch self {
      case .main: return "TITLE_MAIN"
      case .stat: return "TITLE_STATS"
      case .hist: return "TITLE_HISTORY"
      }
    }
    
    var symbol: String {
      switch self {
      case .main: return "house.circle"
      case .stat: return "divide.circle"
      case .hist: return "calendar.circle"
      }
    }
  }
}

// MARK: - Previews

struct AshtrayView_Previews: PreviewProvider {
  static var previews: some View {
    AshtrayView()
  }
}
