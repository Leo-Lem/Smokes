// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct AlltimeTip: Tip {
  let title = Text("Select alltime")
  let message: Text? = Text("View statistics over all time.")
  let image: Image? = Image(systemName: "chevron.forward.to.line")
}
