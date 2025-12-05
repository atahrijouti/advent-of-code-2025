const surrounding_coords = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

def to-record [matrix: list<list<string>>] {
  $matrix | enumerate | reduce --fold {} {|line, acc|
    mut r = {}
    for char in ($line.item | enumerate) {
      if ($char.item == "@") {
        $r = $r | insert $"($line.index),($char.index)" true
      }
    }
    $acc | merge $r
  }
}

def print-matrix-record [record: record, size: list] {
  0..($size.0 - 1) | each {|i|
    (0..($size.1 - 1) | each {|j|
      $record | (get -o $"($i),($j)" | default '.')
    }) | str join
  }
}

def record-weights [matrix: record] {
  $matrix | items {|coords| $coords} | reduce --fold {} {|coords, acc|
    let ints = $coords | split row "," | into int
    let weight = $surrounding_coords | reduce --fold 0 {|scords, weight|
      let row = $scords.0 + $ints.0
      let column = $scords.1 + $ints.1

      let id = $"($row),($column)"
      let value = ($matrix | get -o $id | default false)

      if ($value == true) {
        ($weight + 1)
      } else {
        $weight
      }
    }
    $acc | insert $coords $weight
  }
}

def mark-record [matrix:record] {
  $matrix | items {|k, v| [$k, (if ($v < 4) { "x" } else { "@" })] } | into record
}

def marked-papers [matrix:record] {
  $matrix | items {|k, v| $v} | reduce --fold 0 {|cell, acc|
    if ($cell < 4) {
      return ($acc + 1)
    } else {
      return $acc
    }
  }
}

def filter-marked [matrix: record] {
  $matrix
  | items {|k, v| {k: $k, v: $v}}
  | reduce --fold [] {|cell, acc|
    if ($cell.v < 4) {
      $acc
    } else {
      $acc | append [[$cell.k true]]
    }
  }
  | into record 
}

def part-1 [matrix: record] {
  let weights = record-weights $matrix
  print (marked-papers $weights)
}

def part-2 [matrix: record] {
  mut dict = $matrix
  mut total = 0

  loop {
    let weights = record-weights $dict
    let marked = marked-papers $weights
    if $marked == 0 { break }
    $total += $marked
    $dict = filter-marked $weights
    print $marked
  }

  $total
}

export def main [] {
  let matrix = open input\day004.txt | lines | split chars
  let size = [($matrix | length) ($matrix.0 | length)]
  let dict = to-record $matrix
  # part-1 $dict
  part-2 $dict
}

