// Created by Leopold Lemmermann on 27.04.23.

#if os(iOS)
import SwiftUI

@available(iOS 15, *)
public extension View {
  func compactDismissButton() -> some View {
    overlay(alignment: .topLeading) {
      CompactDismissButton()
        .labelStyle(.iconOnly)
        .padding()
    }
  }
  
  func compactDismissButtonToolbar() -> some View {
    toolbar {
      ToolbarItem(placement: .navigationBarLeading, content: CompactDismissButton.init)
    }
  }
}

@available(iOS 15, *)
public struct CompactDismissButton: View {
  public var body: some View {
    if vSize == .compact {
      Button(action: dismiss.callAsFunction) { Label("Dismiss", systemImage: "chevron.down") }
    }
  }
  
  @Environment(\.verticalSizeClass) private var vSize
  @Environment(\.dismiss) private var dismiss
}

// MARK: - (PREVIEWS)
@available(iOS 16, *)
struct ToolbarDismissButtonForCompactLayout_Previews: PreviewProvider {
  static var previews: some View {
    Text("View")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .compactDismissButton()
      .previewInSheet()
      .previewDisplayName("Bare")
    
    NavigationStack {
      Text("View")
        .compactDismissButtonToolbar()
    }
    .previewInSheet()
    .previewDisplayName("Toolbar")
  }
}
#endif
