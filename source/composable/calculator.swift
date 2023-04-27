// Created by Leopold Lemmermann on 27.04.23.

import ComposableArchitecture

struct Calculator<Parameters: Hashable, Data: Equatable, Result: Equatable>: ReducerProtocol {
  let calculate: (Parameters, Data) async -> Result?
  let needsRecalculation: (Parameters, Data) -> Bool
  
  typealias Cache = Smokes.Cache<Parameters, Result>

  var body: some ReducerProtocol<State, Action> {
    Scope(state: \State.cache, action: /Action.cache, child: Cache.init)

    Reduce<State, Action> { state, action in
      switch action {
      case let .calculate(parameters):
        return .run { [data = state.data] send in
          if let result = await calculate(parameters, data) {
            await send(.cache(.insert(parameters, result)))
          }
        }
        
      case let .setData(data):
        state.data = data
        
        return .run { [cache = state.cache.keyedValues] send in
          for (parameters, _) in cache where needsRecalculation(parameters, data) {
            await send(.calculate(parameters))
          }
        }
        
      default: break
      }

      return .none
    }
  }
  
  init(
    _ calculate: @escaping (Parameters, Data) -> Result,
    needsRecalculation: @escaping (Parameters, Data) -> Bool = { _, _ in true }
  ) {
    self.calculate = calculate
    self.needsRecalculation = needsRecalculation
  }
}

extension Calculator {
  struct State: Equatable {
    fileprivate var cache = Cache.State()
    fileprivate(set) var data: Data
    
    subscript(_ parameters: Parameters) -> Result? { cache.keyedValues[parameters] }
    
    init(_ data: Data) { self.data = data }
  }
}

extension Calculator {
  enum Action {
    case cache(Cache.Action)
    
    case calculate(Parameters)
    case setData(Data)
  }
}
