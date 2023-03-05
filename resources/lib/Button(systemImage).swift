// Created by Leopold Lemmermann on 05.03.23.

import SwiftUI

extension Button {
  init(systemImage: String, action: @escaping () -> Void) where Label == Image {
    self.init(action: action) { Image(systemName: systemImage) }
  }
}
