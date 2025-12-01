const notches = 100

mut rights = 0
mut lefts = 0
mut dial = 50
mut password = 0

let steps = open input/day-1.txt | lines | parse --regex '(R|L)(.*)' | rename r s

for row in $steps {
  let step = $row.s | into int
  let sign = if ($row.r == "L") { -1 } else { 1 }
  if $sign < 0 { $lefts += 1 } else { $rights += 1}

  $dial += $step * $sign
  if ($dial mod $notches == 0) {
    $password += 1
  }
}

{
  password: $password
  dial: $dial,
  lefts: $lefts
  rights: $rights
}
