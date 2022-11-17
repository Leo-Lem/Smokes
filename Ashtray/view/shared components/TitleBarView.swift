//  Created by Leopold Lemmermann on 20.01.22.

import MyCustomUI
import SwiftUI

extension AshtrayView {
  struct TitleBarView: View {
    @Binding var selectedOverlay: Overlay
        
    var body: some View {
      HStack {
        SymbolButton("gear.circle") { selectedOverlay = .pref }
                
        Spacer()
                
        Text(_appTitle).hidden(selectedOverlay != .none)
                
        Spacer()
                
        SymbolButton("info.circle") { selectedOverlay = .info }
      }
    }
  }
}

// MARK: - Previews

struct TitleBar_Previews: PreviewProvider {
  static var previews: some View {
    AshtrayView.TitleBarView(selectedOverlay: .constant(.none))
  }
}
