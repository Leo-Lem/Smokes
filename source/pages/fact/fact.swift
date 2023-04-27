// Created by Leopold Lemmermann on 26.03.23.

import SwiftUI

struct FactView: View {
  @Binding var isPresented: Bool

  var body: some View {
    Text("")
    VStack {
      factBox()
      Spacer()
      progressBar()
    }
    .onReceive(timer) { _ in progress = min(1, progress + 0.01) }
    .onChange(of: progress) { if $0 >= 1 { isPresented = false } }
    .task { await fetchFact() }
  }

  @State private var fact = ""
  @State private var progress = 0.0

  private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

  // TODO: integrate with the facts api
  private func fetchFact() async {
    if let url = Bundle.main.url(forResource: "SmokingFacts", withExtension: "json") {
      do {
        fact ?= try JSONDecoder().decode([String].self, from: Data(contentsOf: url)).randomElement()
      } catch { debugPrint(error) }
    } else {
      debugPrint("Missing bundle resource 'SmokingFacts.json'...")
      isPresented = false
    }
  }
}

extension FactView {
  @ViewBuilder private func factBox() -> some View {
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
  }

  @ViewBuilder private func progressBar() -> some View {
    HStack {
      ProgressView(value: progress)
        .padding(5)
        .background(.ultraThinMaterial)
        .cornerRadius(5)

      Button { isPresented = false } label: { Label("SKIP", systemImage: "chevron.forward.to.line") }
        .buttonStyle(.borderedProminent)
        .labelStyle(.iconOnly)
    }
  }
}

// MARK: - (PREVIEWS)

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    FactView(isPresented: .constant(true))
  }
}
