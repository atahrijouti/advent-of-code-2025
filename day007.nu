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
  mut stack = [{row: 0, col: (( $width / 2) | into int), start: {row: 0, col: (( $width / 2) | into int)}}]
  mut splits = {}
  for line in 0..($height - 1) {
    mut line_stack = []
    for beam in $stack {
      let row = $beam.row
      let col = $beam.col
      let id = $"($row),($col)"
      let beam_on_prism = $prisms | get -o $id | default false
      if ($beam_on_prism) {
        let leftCol = if ($col == 0) { null } else { $col - 1 }
        let rightCol = if ($col == ($width - 1)) { null } else { $col + 1 }
        let potential_left = {
          row: ($row + 1),
          col: $leftCol, start:
          {row: ($row + 1), col: $leftCol}
        } 
        let potential_right = {
          row: ($row + 1),
          col: $rightCol,
          start:{row: ($row + 1), col: $rightCol}
        }
        mut split = false

        let found_left = find-beam $potential_left $line_stack
        if ($found_left | is-empty) {
          $splits = $splits | insert $"($potential_left.row),($potential_left.col)" $"($beam.start.row),($beam.start.col)" 
          $line_stack ++= [$potential_left]
          $split = true
        }
        let found_right = find-beam $potential_right $line_stack
        if ($found_right | is-empty) {
          $splits = $splits | insert $"($potential_right.row),($potential_right.col)" $"($beam.start.row),($beam.start.col)" 
          $line_stack ++= [$potential_right]
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
  {
    stack: $stack,
    split_count: $count,
    splits: $splits
  }
}

def main [] {
  print --raw (part-2)
}
