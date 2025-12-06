def main [] {
  let contents = open input\day005.txt
  # let contents = open input\sample.txt
  let parts = $contents | (split row "\n\n")
  let ranges = $parts.0 | lines | each {|s| $s | split row "-" | into int}
  let ids = $parts.1 | lines | into int
  mut fresh = 0

  for id in $ids {
    for range in $ranges {
      if ($range.0 <= $id and $id <= $range.1) {
        $fresh += 1
        break
      }
    }
  }

  $fresh
}
