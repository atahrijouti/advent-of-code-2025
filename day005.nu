def ranges-intersect [a: list<int>, b: list<int>] {
  let brange = $b.0..$b.1
  let arange = $a.0..$a.1
  if (
    $a.0 in $brange
    or $a.1 in $brange
    or $b.0 in $arange
    or $b.1 in $arange
  ) {
    true
  } else {
    false
  }
}

def merge-ranges [a: list<int>, b: list<int>] {
  [
    ([ $a.0 $b.0 ] | math min)
    ([ $a.1 $b.1 ] | math max)
  ]
}

def merge-many-ranges [ranges: list<list<int>>] {
  if ($ranges | length) == 0 {
    return []
  }
  if ($ranges | length) == 1 {
    return $ranges.0
  }
  let min = $ranges | each {|r| $r.0} | math min
  let max = $ranges | each {|r| $r.1} | math max

  return [$min $max]
}

def find-intersects [range: list<int>, list: list<list<int>>] {
  $list | where (ranges-intersect $range $it)
}

def range-id [range: list<int>] {
  $"($range.0),($range.1)"
}

def part-2 [] {
  let contents = open input\day005.txt
  # let contents = open input\sample.txt
  let parts = $contents | (split row "\n\n")
  let ranges = $parts.0 | lines | each {|s| $s | split row "-" | into int}

  mut queue = [...$ranges]
  mut result = []
  mut loops = 0

  loop {
    if ($queue | length) == 0 {
      break
    }
    $loops += 1

    let current = $queue | first
    let rest = $queue | skip 1

    let intersects = find-intersects $current $rest

    if ($intersects | length) == 0 {
      $result ++= [$current]
      $queue = $rest
    } else {
      let merged = merge-many-ranges [$current ...$intersects]

      let filtered = $queue | where (($it not-in $intersects) and $it != $current)
      $queue = [...$filtered $merged]
    }
  }


  $result | sort-by -c {|a,b| $a.0 < $b.0}
  $result | reduce --fold 0 {|range, count|
    $count + ($range.1 - $range.0) + 1
  }

}

def part-1 [] {
  let contents = open input/day005.txt
  let parts = $contents | (split row "\n\n")
  let ranges = $parts.0 | lines | each {|s| $s | split row "-" | into int}
  let ids = $parts.1 | lines | into int
  mut fresh = 0

  for id in $ids {
    for range in $ranges {
      if $id in $range.0..$range.1 {
        $fresh += 1
        break
      }
    }
  }

  $fresh
  
}

def main [] {
  part-2
}
