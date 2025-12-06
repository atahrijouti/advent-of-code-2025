const S = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

def sample [] {
  let lines = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +" | lines
  let table = $lines | str trim | each {|line| $line | split row -r '\s+'} 
  let width = $table | length
  let height = $table.0 | length

  mut $tt = []
  for j in 0..($height - 1) {
    mut line = []
    for i in 0..($width - 1) {
      let raw = ($table | get ([$i $j] | into cell-path))
      let value = if ($i < 3) { $raw | into int } else { $raw }
      $line ++= [ $value ]
    }
    $tt ++= [$line]
  }
  $tt
  
}

def make-nuon [] {
  let lines = open input\day006.txt | lines
  let table = $lines | str trim | each {|line| $line | split row -r '\s+'} 
  let width = $table | length
  let height = $table.0 | length

  mut $tt = []
  for j in 0..($height - 1) {
    mut line = []
    for i in 0..($width - 1) {
      let raw = ($table | get ([$i $j] | into cell-path))
      let value = if ($i < 4) { $raw | into int } else { $raw }
      $line ++= [ $value ]
    }
    $tt ++= [$line]
  }
  $tt
}

def part-1 [] {
  open input/day006.nuon | each {|list|
    let numbers = $list | drop 1
    let operation = $list | last
    if $operation == "+" {
      $numbers | math sum 
    } else {
      $numbers | math product 
    }
  } | math sum
}

# ╭───┬─────────────────╮
# │ 0 │  46 15  823 321 │
# │ 1 │  32 783  46 54  │
# │ 2 │ 413 512  89 6   │
# │ 3 │   +   *   +   * │
# ╰───┴─────────────────╯
 
def day-2 [] {
  let input = open input\day006.txt | lines | split chars | each {|line| $line | reverse }
  # let newfile = $input | each {|line| $line | str join }
  # $newfile | save -f input/day006-reversed.txt
  let operators = $input | last
  let o = $operators
  mut index = 0
  mut count = 0
  mut stack = []

  # 0 : collect
  # 1 : operator
  # 2 : separator
  mut mode = 0
  for c in $o {
    match $mode {
      0 => {
       if ($c != " ") {
          $mode = 1
        }
      }
      1 => {
        $mode = 2
      }
      2 => {
        $mode = 0
      }
    }

    if ($mode != 2) {
      let raw = ([
        ($input | get ([0 $index] | into cell-path))
        ($input | get ([1 $index] | into cell-path))
        ($input | get ([2 $index] | into cell-path))
        ($input | get ([3 $index] | into cell-path))
      ])

      # print $index

      let number = $raw | str join | str trim | into int

      $stack ++= [$number]
    }

    if ($mode == 1) {
      $count += if $c == "+" {
        $stack | math sum 
      } else {
        $stack | math product 
      }
      $stack = []
    }
    
    # print $mode
    $index += 1
  }
  $count
}

def main [] {
  day-2
}
