// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct FactTip: Tip {
  let title = Text(.localizable(.factTipTitle))
  let message: Text? = Text(.localizable(.factTipMessage))
  let image: Image? = Image(systemName: "lightbulb")
}
