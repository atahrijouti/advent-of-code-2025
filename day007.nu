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

  let prisms = $matrix | reduce --fold {} {|l, acc|
    $acc | merge ($l.item | reduce --fold {} {|c, acc|
      if $c.item == "^" {
        ($acc | upsert $"($l.index),($c.index)" true)
      } else {
        $acc
      }
    })
  } 

  return ($prisms | items {|k,v| $k})
}

def main [] {
  part-2
}
