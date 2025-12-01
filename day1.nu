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

 # ------------------------------
 # -90 - 190 = -280 
 #  10 & 190 = 10 --> 0 --> -100 --> -180
 # ------------------------------
 # -90 + 190 = 100
 #  10 + 190 = 10 --> 100 --> 200
 # ------------------------------
 # 90 + 190 = 280
 # 90 + 190 = 90 --> 100 --> 200 --> 280
 # ------------------------------
 # 90 - 190 = -100
 # 90 - 190 = 90 --> 0 --> -100
def zero-passes [number: int, step: int] {
  let current_notch = notch ($number)
  (($current_notch + $step) / $notches) | into int
}

for row in $steps {
  let step = $row.s | into int
  let sign = if ($row.r == "L") { -1 } else { 1 }
  if $sign < 0 { $lefts += 1 } else { $rights += 1 }

  $past_zero += zero-passes $dial $step

  $dial += $step * $sign
  # print (notch ($dial))

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
