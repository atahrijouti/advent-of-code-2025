const sample = ".......^.......
......^.^......
.....^.^.^.....
....^.^...^....
...^.^...^.^...
..^...^.....^..
.^.^.^.^.^...^."
def part-2 [] {
  let matrix = $sample | lines | each {|l| ($l | split chars) | enumerate } | enumerate

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
  mut stack = [{row: 0, col: (( $width / 2) | into int)}]
  for line in 0..($height - 1) {
    mut line_stack = []
    for beam in $stack {
      let row = $beam.row
      let col = $beam.col
      let id = $"($row),($col)"
      let exists = $prisms | get -o $id | default false
      if ($exists) {
        let leftCol = if ($col == 0) { null } else { $col - 1 }
        let rightCol = if ($col == ($width - 1)) { null } else { $col + 1 }
        let potentialLeft = { row: ($row + 1), col: $leftCol } 
        let potentialRight = { row: ($row + 1), col: $rightCol }
        mut split = false
        if $potentialLeft not-in $line_stack {
          $line_stack ++= [$potentialLeft]
          $split = true
        }
        if $potentialRight not-in $line_stack {
          $line_stack ++= [$potentialRight]
          $split = true
        }
        if $split {
          $splits += 1
        }
      } else {
        let potentialBeam = {row: ($row + 1), col: $col}
        if $potentialBeam not-in $line_stack {
          $line_stack ++= [{row: ($row + 1), col: $col}]
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
  part-2
}
