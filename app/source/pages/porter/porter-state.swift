// Created by Leopold Lemmermann on 05.03.23.

extension Porter {
  struct ViewState: Equatable {
    let file: DataFile?
    
    init(_ state: App.State) {
      file = state.file?.data.flatMap(DataFile.init)
    }
  }
}
