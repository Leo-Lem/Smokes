// Created by Leopold Lemmermann on 25.03.23.

import SwiftUI

struct TimeInfo: View {
  let timeInterval: TimeInterval?, description: LocalizedStringKey
  
  var body: some View {
    BaseInfo(formatted, description: Text(description))
  }
  
  private var formatted: Text? {
    guard let timeInterval else { return nil }
    
    if timeInterval.isInfinite { return Text("NO_DATA") }
    
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute]
    return Text(formatter.string(from: timeInterval)!)
  }
  
  init(_ timeInterval: TimeInterval?, description: LocalizedStringKey) {
    (self.timeInterval, self.description) = (timeInterval, description)
  }
}

// MARK: - (PREVIEWS)

struct TimeInfo_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      TimeInfo(9999, description: "time since last")
    }
  }
}
