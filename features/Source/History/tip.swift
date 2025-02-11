// Created by Leopold Lemmermann on 11.02.25.

import TipKit

struct EditTip: Tip {
  let title = Text("Edit history")
  let message: Text? = Text("Modify the past amounts here.")
  let image: Image? = Image(systemName: "square.and.pencil")
}
