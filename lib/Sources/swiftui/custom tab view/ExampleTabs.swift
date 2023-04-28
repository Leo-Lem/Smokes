// Created by Leopold Lemmermann on 31.03.23.

import SwiftUI

enum Example3Tab: String, Tabbable {
  case awards, history = "", dashboard

  var tab: some View {
    Text(rawValue + " (HELLO)")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  var tabItem: some View {
    VStack {
      Image(systemName: "square")
        .imageScale(.large)
      
      Text(rawValue)
        .font(.caption)
    }
    .foregroundColor(.primary)
    .padding()
  }
}

enum Example4Tab: String, Tabbable {
  case awards, history = "", dashboard, stats

  var tab: some View {
    Text(rawValue + " (HELLO)")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  var tabItem: some View {
    VStack {
      Image(systemName: "square")
        .imageScale(.large)
      
      Text(rawValue)
        .font(.caption)
    }
    .foregroundColor(.primary)
    .padding()
  }
}

enum Example5Tab: String, Tabbable {
  case awards, history = "", dashboard, stats, money

  var tab: some View {
    Text(rawValue + " (HELLO)")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  var tabItem: some View {
    VStack {
      Image(systemName: "square")
        .imageScale(.large)
      
      Text(rawValue)
        .font(.caption)
        .lineLimit(1)
    }
    .foregroundColor(.primary)
    .padding()
  }
}
