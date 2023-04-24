// Created by Leopold Lemmermann on 26.03.23.

import SwiftUI

struct LaunchPage: View {
  @Binding var progress: Double

  var body: some View {
    VStack {
      VStack {
        Text(fact)
          .font(.headline)
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .minimumScaleFactor(0.7)

        Color.accentColor
          .frame(maxWidth: 100, maxHeight: 2)
          .cornerRadius(2)

        Text("FACT_OF_THE_DAY")
          .font(.subheadline)
      }
      .frame(maxWidth: .infinity)
      .padding(5)
      .background(.ultraThinMaterial)
      .cornerRadius(5)

      Spacer()

      HStack {
        ProgressView(value: progress)
          .padding(5)
          .background(.ultraThinMaterial)
          .cornerRadius(5)

        Button { progress = 0.98 } label: { Label("SKIP", systemImage: "chevron.forward.to.line") }
          .buttonStyle(.borderedProminent)
      }
    }
    .padding()
    .background { Background() }
    .task {
      // TODO: integrate with the facts api
      if let url = Bundle.main.url(forResource: "SmokingFacts", withExtension: "json") {
        do {
          fact ?= try JSONDecoder().decode([String].self, from: Data(contentsOf: url)).randomElement()
        } catch {
          debugPrint(error)
        }
      } else {
        debugPrint("Missing bundle resource 'SmokingFacts.json'...")
        progress = 1
      }
    }
  }

  @State private var fact = ""

  @Environment(\.verticalSizeClass) private var vSize
}

// MARK: - (PREVIEWS)

struct LoadingPage_Previews: PreviewProvider {
  static var previews: some View {
    LaunchPage(progress: .constant(0.1))
      .environment(\.verticalSizeClass, .regular)
      .previewDisplayName("Regular")
  }
}
