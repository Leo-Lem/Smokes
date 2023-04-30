// Created by Leopold Lemmermann on 26.03.23.

import SwiftUI

struct FactView: View {
  @Binding var isPresented: Bool

  var body: some View {
    VStack {
      factBox()
      Spacer()
      progressBar()
    }
    .animation(.easeInOut(duration: 2), value: fact)
    .onReceive(timer) { _ in progress = min(1, progress + 0.01) }
    .onChange(of: progress) { if $0 >= 1 { isPresented = false } }
    .task { await fetch() }
  }

  @AppStorage("smokes_fact") private var fact = String(localized: "COMING_SOON")
  @State private var progress = 0.0

  private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

  private func fetch() async {
    do {
      let url = FACTS_URL.appendingPathComponent(LANGUAGE_CODE.identifier)
      let (data, response) = try await URLSession.shared.data(from: url)
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
      
      fact ?= String(data: data, encoding: .utf8)
    } catch { debugPrint("Fetching failed") }
  }
}

extension FactView {
  @ViewBuilder private func factBox() -> some View {
    VStack {
      Text(fact)
        .font(.headline)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.7)

      Color.accentColor
        .frame(maxWidth: 100, maxHeight: 2)
        .cornerRadius(2)

      Text("SMOKES_FACTs")
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
