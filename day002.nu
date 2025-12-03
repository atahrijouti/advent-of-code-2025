# part 1
def mirrored-string [str: string] {
  let strlen = $str | str length
  if ($strlen == 0) {
    return false
  }
  
  if ($strlen mod 2 == 1) {
    return false
  }
  let middle = ($strlen / 2) | into int
  let head = $str | str substring 0..($middle - 1)
  let tail = $str | str substring $middle..$strlen
  $head == $tail
}

# part 2
def repeated-patterns [str: string] {
  let repeated = $str | parse --regex '^(\d+?)\1+$'
  if ($repeated | length) == 1 {
    return true
  }
  return false
}

def invalids-in-range (start: int, end: int) {
  mut invalids = []
  for n in $start..$end {
    let strn = $n | into string
    if (repeated-patterns $strn) {
      $invalids = ($invalids | append $n)
    }
  }

  $invalids
}

def main [] {
  let rows = open --raw input/day002.txt | lines | split row "," | parse -r "(.*)-(.*)" | rename start end

  mut invalids = []
  for row in $rows {
    let start = $row.start | into int
    let end = $row.end | into int
    $invalids ++= invalids-in-range $start $end
  }

  {
    invalids: $invalids,
    sum: ($invalids | math sum)
  }
}
