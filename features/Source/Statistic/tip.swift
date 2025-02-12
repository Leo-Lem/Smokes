// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct AlltimeTip: Tip {
  let title = Text(.localizable(.alltimeTipTitle))
  let message: Text? = Text(.localizable(.alltimeTipMessage))
  let image: Image? = Image(systemName: "chevron.forward.to.line")
}
