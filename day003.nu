mut a = 0
mut b = 0
mut c = 0

def best-batteries [line: string] {
  mut a = 0
  mut b = 0
  for chr in ($line | split chars) {
    let c = $chr | into int
    if ($a * 10 + $b) < ($b * 10 + $c) {
      $a = $b
      $b = $c
    } else if $b < $c {
      $b = $c
    }
  }
  $a * 10 + $b
}

def part-1 [] {
  open input/day003.txt | lines | each {|bank| (best-batteries $bank)} | math sum
}

def main [] {
  part-1
}
