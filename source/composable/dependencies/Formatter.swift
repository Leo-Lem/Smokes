// Created by Leopold Lemmermann on 01.04.23.

import Dependencies
import SwiftUI

extension DependencyValues {
  var formatter: Formatter {
    get { self[Formatter.self] }
    set { self[Formatter.self] = newValue }
  }
}

struct Formatter {
  func format(amount: Int) -> Text {
    Text("\(amount) SMOKES_PLURAL_VALUE")
      + Text(" ")
      + Text("\(amount) SMOKES_PLURAL_LABEL").font(.headline)
  }
  
  func format(average: Double) -> Text {
    let rounded = (average * 100).rounded() / 100
    
    return Text("\(rounded) SMOKES_PLURAL_VALUE")
      + Text(" ")
      + Text("\(rounded) SMOKES_PLURAL_LABEL").font(.headline)
  }
  
  func format(time: TimeInterval) -> Text {
    if time.isInfinite { return Text("NO_DATA") }
    
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute]
    return Text(formatter.string(from: time)!)
  }
  
  func format(trend: Double) -> Text {
    if trend != 0 {
      return Text(trend > 0 ? "+" : "") + format(average: trend)
    } else {
      return Text("NO_DATA")
    }
  }
  
  @_disfavoredOverload
  func format(amount: Int?) -> Text? { amount.flatMap { format(amount: $0) } }
  
  @_disfavoredOverload
  func format(average: Double?) -> Text? { average.flatMap { format(average: $0) } }
  
  @_disfavoredOverload
  func format(time: TimeInterval?) -> Text? { time.flatMap { format(time: $0) } }
  
  @_disfavoredOverload
  func format(trend: Double?) -> Text? { trend.flatMap { format(trend: $0) } }
}

extension Formatter: DependencyKey {
  static var liveValue = Formatter()
}
