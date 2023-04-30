// Created by Leopold Lemmermann on 31.03.23.

import SwiftUI

public protocol Tabbable: Hashable, CaseIterable {
  associatedtype Tab: View
  associatedtype TabItem: View
  
  @ViewBuilder var tab: Tab { get }
  @ViewBuilder var tabItem: TabItem { get }
}
