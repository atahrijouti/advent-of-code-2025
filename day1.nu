const notches = 100

mut rights = 0
mut lefts = 0
mut dial = 50
mut password = 0

let steps = open input/day-1.txt | lines | parse --regex '(R|L)(.*)' | rename r s

def part-1 [current: int] {
  if ($current mod $notches == 0) {
    return true
  }
  return false
}

def part-2 [rotation: string, before: int, after: int] {
}

for row in $steps {
  let step = $row.s | into int
  let sign = if ($row.r == "L") { -1 } else { 1 }
  if $sign < 0 { $lefts += 1 } else { $rights += 1}

  let before_dial = $dial
  $dial += $step * $sign

  # if (part-1 $dial) {
  #   $password += 1
  # }

  
}

{
  password: $password
  dial: $dial,
  lefts: $lefts
  rights: $rights
}
