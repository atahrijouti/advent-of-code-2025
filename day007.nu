const sample = ".......S.......
.......^.......
......^.^......
.....^.^.^.....
....^.^...^....
...^.^...^.^...
..^...^.....^..
.^.^.^.^.^...^."
def part-2 [] {
  let matrix = $sample | lines | each {|l| ($l | split chars) | enumerate } | enumerate

  $matrix | reduce --fold {} {|l, acc|
    $acc | merge ($l.item | reduce --fold {} {|c, acc|
      if $c.item == "^" {
        ($acc | upsert $"($l.index),($c.index)" true)
      } else {
        $acc
      }
    })
  } 
}

def main [] {
  part-2
}
