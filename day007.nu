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

  let splits = 0
  mut stack = [{row: 0, col: (( $width / 2) | into int)}]
  for line in 0..($height - 1) {
    mut line_stack = []
    for beam in $stack {
      let id = $"($beam.row),($beam.col)"
      let exists = $prisms | get -o $id | default false
      if (not $exists) {
        break;
      }
    }
  }

}

def main [] {
  part-2
}
