// Created by Leopold Lemmermann on 05.03.23.

extension Porter {
  enum ViewAction {
    case encode
    case selectCoder(EntriesEncoding)
    case setData(Data)
    
    static func send(_ action: Self) -> App.Action {
      switch action {
      case .encode: return .file(.encode)
      case let .selectCoder(encoding): return .file(.setEncoding(encoding))
      case let .setData(data): return .file(.setData(data))
      }
    }
  }
}
