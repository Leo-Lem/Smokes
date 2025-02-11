// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct OptionTip: Tip {
  let title = Text("Select an option")
  let message: Text? = Text("Individualize your experience.")
  let image: Image? = Image(systemName: "arrowtriangle.down.circle.fill")
}

struct TransferTip: Tip {
  let title = Text("Export and Import")
  let message: Text? = Text("Keep your data safe and easily accessible.")
  let image: Image? = Image(systemName: "folder")
}
