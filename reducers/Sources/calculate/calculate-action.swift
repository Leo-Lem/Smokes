// Created by Leopold Lemmermann on 28.04.23.

public extension Calculate {
  enum Action {
    case filter(Interval),
         filterAmounts(Interval, Subdivision),
         amount(Interval),
         average(Interval, Subdivision),
         trend(Interval, Subdivision),
         averageBreak(Interval)

    case allAmounts(IntervalAndSubdivision)
    
    case setEntries(Entries.State)

    case filtereds(Filter.Action),
         filteredAmounts(AmountsFilter.Action),
         amounts(Amounter.Action),
         averages(Averager.Action),
         trends(Trender.Action),
         averageBreaks(BreakAverager.Action)
  }
}
