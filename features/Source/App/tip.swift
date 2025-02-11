// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct FactTip: Tip {
  let title = Text("Smokes' Facts", comment: "Title of the fact tip.")
  let message: Text? = Text("View an interesting fact about smoking.")
  let image: Image? = Image(systemName: "lightbulb")
}
