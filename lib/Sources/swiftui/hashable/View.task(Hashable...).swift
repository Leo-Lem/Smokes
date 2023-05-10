// Created by Leopold Lemmermann on 10.05.23.

import SwiftUI

public extension View {
  func onChange<T>(
    of values: AnyHashable...,
    update binding: Binding<T?>,
    priority: TaskPriority = .userInitiated,
    with update: @Sendable @escaping () async -> T?
  ) -> some View {
    task(id: CombineHashable(values), priority: priority) {
      await MainActor.run { binding.wrappedValue = nil }
      let result = await update()
      await MainActor.run { binding.wrappedValue = result }
    }
  }
}
