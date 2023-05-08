# Sorting theory.
# Richard St-Denis, Universite de Sherbrooke, 2020.

alloy :Sorting do
  abstract sig Index [
    rank: (one Int) ] { }

  abstract sig ArrayOfInt [
    v: Index ** one(Int),           # total function
    ub: Index ] { }

  abstract sig Permutation [        # bijective function
    f: Index ** one(Index) ] {      # total function
    all(j: Index) { one(f.(j)) } }  # injective function

  pred sorted[a: (one ArrayOfInt), p: (one Permutation)] {
    all(j: Index) { all(k: Index) {
      (j.(p.f)).(a.v) <= (k.(p.f)).(a.v) if
        j != a.ub and k.rank == j.rank + 1 } } }

  pred stablySorted[a: (one ArrayOfInt), p: (one Permutation)] {
    sorted(a, p) and
    all(j: Index) { all(k: Index) {
      (j.(p.f)).rank < (k.(p.f)).rank if
        j != a.ub and k.rank == j.rank + 1 and
        (j.(p.f)).(a.v) == (k.(p.f)).(a.v) } } }

  fun sort[a: (one ArrayOfInt), p: (one Permutation)] [(set Index ** one(Int))] {
    (Index ** Int).select { |idx, val| sorted(a, p) and
                            (idx ** val).in? (p.f).(a.v) } }

  fun sortStably[a: (one ArrayOfInt), p: (one Permutation)] [(set Index ** one(Int))] {
    (Index ** Int).select { |idx, val| stablySorted(a, p) and
                            (idx ** val).in? (p.f).(a.v) } }

  pred immutable[a: (one ArrayOfInt), p: (one Permutation)] {
    # If "a" is immutable under sorting, then the permutation of its
    # stable sort is the identity
    (p.f == (Index.<iden) if a.v == (p.f).(a.v)) }
end