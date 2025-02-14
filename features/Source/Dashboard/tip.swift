// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct OptionTip: Tip {
  let title = Text(.localizable(.optionTipTitle))
  let message: Text? = Text(.localizable(.optionTipMessage))
  let image: Image? = Image(systemName: "arrowtriangle.down.circle.fill")
}

struct TransferTip: Tip {
  let title = Text(.localizable(.transferTipTitle))
  let message: Text? = Text(.localizable(.transferTipMessage))
  let image: Image? = Image(systemName: "folder")
}
