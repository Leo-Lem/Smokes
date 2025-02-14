// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct EditTip: Tip {
  let title = Text(.localizable(.editTipTitle))
  let message: Text? = Text(.localizable(.editTipMessage))
  let image: Image? = Image(systemName: "square.and.pencil")
}
