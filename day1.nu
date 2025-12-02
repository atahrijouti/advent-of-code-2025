const notches = 100

mut rights = 0
mut lefts = 0
mut dial = 50
mut on_zero = 0
mut past_zero = 0

let steps = open input/day001.txt | lines | parse --regex '(R|L)(.*)' | rename r s

def notch [d: number] {
  let mod_rest = ($d mod $notches)
  if ($mod_rest < 0) {
    return ($mod_rest + $notches)
  } else {
    return $mod_rest  
  }
}

def zero-passes [number: int, step: int, sign: int] {
  let current_notch = notch ($number)

  let count_start = (if $sign < 0 { $notches - $current_notch } else { $current_notch }) mod $notches

  (($count_start + $step) / $notches) | into int
}

for row in $steps {
  let step = $row.s | into int
  let sign = if ($row.r == "L") { -1 } else { 1 }
  if $sign < 0 { $lefts += 1 } else { $rights += 1 }

  $past_zero += zero-passes $dial $step $sign

  $dial += $step * $sign

  if ($dial mod $notches == 0) {
    $on_zero += 1
  }
}

{
  past_zero: $past_zero,
  on_zero: $on_zero,
  dial: $dial,
  lefts: $lefts
  rights: $rights
}
