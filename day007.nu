const sample = ".......^.......
......^........
.....^.........
....^..........
...^...........
..^............
.^............."

def find-beam [beam: record, stack: list] {
  $stack | where {|it|
    $it.row == $beam.row and $it.col == $beam.col
  }
}

def part-2 [] {
  # let matrix = $sample | lines | each {|l| ($l | split chars) | enumerate } | enumerate
  let matrix = open input/day007.txt | lines | each {|l| ($l | split chars) | enumerate } | enumerate

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

  mut splits = 0
  mut stack = [{row: 0, col: (( $width / 2) | into int), splits: []}]
  for line in 0..($height - 1) {
    mut line_stack = []
    for beam in $stack {
      let row = $beam.row
      let col = $beam.col
      let beam_splits = $beam.splits
      let id = $"($row),($col)"
      let beam_on_prism = $prisms | get -o $id | default false
      if ($beam_on_prism) {
        let leftCol = if ($col == 0) { null } else { $col - 1 }
        let rightCol = if ($col == ($width - 1)) { null } else { $col + 1 }
        let potentialLeft = { row: ($row + 1), col: $leftCol, splits: [{row: $row, col: $col}, ...$beam_splits]} 
        let potentialRight = { row: ($row + 1), col: $rightCol, splits: [{row: $row, col: $col}, ...$beam_splits]}
        mut split = false
        let findsLeft = find-beam $potentialLeft $line_stack
        let findsRight = find-beam $potentialRight $line_stack
        if ($findsLeft | is-empty) {
          $line_stack ++= [$potentialLeft]
          $split = true
        }
        if ($findsRight | is-empty) {
          $line_stack ++= [$potentialRight]
          $split = true
        }
        if $split {
          $splits += 1
        }
      } else {
        let potentialBeam = {row: ($row + 1), col: $col, splits: $beam_splits}
        if $potentialBeam not-in $line_stack {
          $line_stack ++= [{row: ($row + 1), col: $col, splits: $beam_splits}]
        }
      }
    }
    $stack = $line_stack
  }
  {
    stack: $stack,
    splits: $splits
  }
}

def main [] {
  print --raw (part-2)
}
