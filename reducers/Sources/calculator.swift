// Created by Leopold Lemmermann on 28.04.23.

public struct Calculator<Parameters: Hashable, Data: Hashable, Result: Equatable>: ReducerProtocol {
  let calculate: (Parameters, Data) async -> Result?

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case let .calculate(parameters):
      return .run { [data = state.data] send in
        if let result = await calculate(parameters, data) {
          await send(.setResult(result, for: parameters))
        }
      }

    case let .setData(data):
      state.data = data

      return .run { [allParameters = state.cache.keys] send in
        for parameters in allParameters { await send(.calculate(parameters)) }
      }

    case let .setResult(result, parameters):
      state.cache[parameters] = result
    }

    return .none
  }

  init(_ calculate: @escaping (Parameters, Data) async -> Result?) { self.calculate = calculate }
}

public extension Calculator {
  struct State: Equatable {
    public internal(set) var cache = [Parameters: Result]()
    public internal(set) var data: Data

    public subscript(_ parameters: Parameters) -> Result? { cache[parameters] }

    public init(_ data: Data) { self.data = data }
  }
}

public extension Calculator {
  enum Action {
    case calculate(Parameters)

    case setData(Data),
         setResult(Result, for: Parameters)
  }
}
