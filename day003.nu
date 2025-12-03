def workable [string: string, left: int, right: int] {
  let len = $string | str length
  $string | str substring ($left + 1)..($len - ($right))
}

def find-left-most-max [workable: string] {
  mut index = 0
  mut max = 0
  mut max_index = 0
  for n in ($workable | split chars | into int | reverse) {
    if $n >= $max {
      $max = $n
      $max_index = $index
    }
    $index += 1
  }
  {
    value: $max,
    index: (($workable | str length) - $max_index - 1)
  }
}

def get-battery [size: int, string: string] {
  mut battery = []
  mut left = -1
  for i in 0..($size - 1) {
    let $w = workable $string $left ($size - $i)
    let max = find-left-most-max $w
    let max_index = $max.index
    let max_value = $max.value

    $left += $max_index + 1

    $battery = $battery | append $max_value
  }
  $battery | into string | str join | into int
}

def part-1 [] {
  let SIZE = 2
  open input/day003.txt | lines | each {|line| (get-battery $SIZE $line)} | math sum 
}

def part-2 [] {
  let SIZE = 12
  open input/day003.txt | lines | each {|line| (get-battery $SIZE $line)} | math sum 
}

def main [] {
  print (part-1)
  print (part-2)
}
