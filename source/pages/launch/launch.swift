// Created by Leopold Lemmermann on 26.03.23.

import SwiftUI

// TODO: add landscape

struct LaunchPage: View {
  @Binding var progress: Double

  var body: some View {
    GeometryReader { _ in
      VStack {
        Spacer()
        
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
        .padding(.horizontal)
        
        HStack {
          ProgressView(value: progress)
          Button("SKIP") { progress = 0.98 }
            .buttonStyle(.borderedProminent)
        }
        .padding([.horizontal, .bottom])
      }
      .background { Background() }
      .onAppear {
        if let url = Bundle.main.url(forResource: "SmokingFacts", withExtension: "json") {
          do {
            fact ?= try JSONDecoder().decode([String].self, from: Data(contentsOf: url)).randomElement()
          } catch {
            debugPrint(error)
          }
        } else {
          debugPrint("Missing bundle resource 'SmokingFacts.json'...")
        }
      }
    }
  }
  
  @State private var fact = ""
}

// MARK: - (PREVIEWS)

struct LoadingPage_Previews: PreviewProvider {
  static var previews: some View {
    LaunchPage(progress: .constant(0.1))
  }
}
