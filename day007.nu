const sample = ".......^.......
......^.^......
.....^.^.^.....
....^.^...^....
...^.^...^.^...
..^...^.....^..
.^.^.^.^.^...^."

def find-beam [beam: record, stack: list] {
  $stack | where {|it|
    $it.row == $beam.row and $it.col == $beam.col
  }
}

def part-2 [] {
  let matrix = $sample | lines | each {|l| ($l | split chars) | enumerate } | enumerate
  # let matrix = open input/day007.txt | lines | each {|l| ($l | split chars) | enumerate } | enumerate

  let width = $matrix.0.item | length
  let height = $matrix | length

  let prisms = $matrix | reduce --fold {} {|l, acc|
    $acc | merge ($l.item | reduce --fold {} {|c, acc|
      if $c.item == "^" {
        ($acc | upsert $"($l.index),($c.index)" true)
      } else {
        $acc
      }
    })
  }

  mut count = 0
  mut stack = [{
    row: 0,
    col: (( $width / 2) | into int),
    start: {row: 0, col: (( $width / 2) | into int)}
  }]
  mut splits = {}
  mut all_splits = {}

  for line in 0..($height - 1) {
    mut line_stack = []
    for beam in $stack {
      let row = $beam.row
      let col = $beam.col
      let prism_id = $"($row),($col)"
      let beam_on_prism = $prisms | get -o $prism_id | default false
      if ($beam_on_prism) {
        let leftCol = if ($col == 0) { null } else { $col - 1 }
        let rightCol = if ($col == ($width - 1)) { null } else { $col + 1 }
        let left = {
          row: ($row + 1),
          col: $leftCol, start:
          {row: ($row + 1), col: $leftCol}
        } 
        let right = {
          row: ($row + 1),
          col: $rightCol,
          start:{row: ($row + 1), col: $rightCol}
        }
        mut split = false

        let left_id = $"($left.row),($left.col)"
        let right_id = $"($right.row),($right.col)"
        let beam_id = $"($beam.start.row),($beam.start.col)"

        if ($beam_id not-in $splits) {
          $splits = $splits | insert $beam_id {}
          $all_splits = $all_splits | insert $beam_id {}
        }

        let found_left = find-beam $left $line_stack
        $all_splits = $all_splits | insert ([$beam_id $left_id] | into cell-path) "L"
        if ($found_left | is-empty) {
          $splits = $splits | insert ([$beam_id $left_id] | into cell-path) "L"
          $line_stack ++= [$left]
          $split = true
        }
        let found_right = find-beam $right $line_stack
        $all_splits = $all_splits | insert ([$beam_id $right_id] | into cell-path) "R"
        if ($found_right | is-empty) {
          $splits = $splits | insert ([$beam_id $right_id] | into cell-path) "R"
          $line_stack ++= [$right]
          $split = true
        }
        if $split {
          $count += 1
        }
      } else {
        let potential_beam = {row: ($row + 1), col: $col, start: $beam.start}
        let found_beam = find-beam $potential_beam $line_stack
        if ($found_beam | is-empty) {
          $line_stack ++= [$potential_beam]
        }
      }
    }
    $stack = $line_stack
  }
  # $splits | save -f output/day007-part-2-sample-splits.nuon
  $all_splits | save -f output/day007-part-2-sample-all-splits.nuon
  
  # $splits | into sqlite day007.db
  {
    stack: $stack,
    split_count: $count,
    splits: $splits
  }
}

let ancestry = open output/day007-part-2-sample-all-splits.nuon
def walk-tree [id: string] {
  let node = $ancestry | get -o $id | default null
  if ($node | is-empty) {
    return $id
  }
  let children = $node | items {|k| $k} | each {|n| walk-tree ($n)}
  return $children
}

def main [] {
  print --raw (walk-tree "0,7")
}
