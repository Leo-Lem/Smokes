// Created by Leopold Lemmermann on 10.05.23.

import SwiftUI

public extension View {
  func animation(_ animation: Animation?, values: AnyHashable...) -> some View {
    self.animation(.default, value: CombineHashable(values))
  }
}
