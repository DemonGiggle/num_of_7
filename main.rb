#!/usr/bin/env ruby

# The algorithm describes as follows:
# The number of 7 occurances for number N can be the sum of the two factors:
#   1. number of 7 occurances for number 1 ~ (nearest ten power number - 1)
#   2. number of 7 occurances for number (nearest ten power number) ~ N
# where factor 2 above detailed as:
#   1. if the highest digit is 7, the occurance count is factor 2 number count
#   2. if not, the highest digit can be ignore, the occurance count is the same as remainder number
#
# For example, assume N = 3952, and assume `occurances[n]` holds the number
# of 7 occurances upto number `n`
#
# Then we will have occurances[3952] = occurances[2999] + (check 3000~3952)
# Since 3 is not 7, the second factor can reduce to occurances[952].
#
# So occurances[3592] = occurances[2999] + occurances[952]
#
# If N = 792, occurances[792] = occurances[699] + (check 700~792).
# Since highest digit is 7, the second factor will be 792.
#
# So occurances[792] = occurances[699] + 93
#
# Now we are going to estimate the bigO.
#
# If each a number is hit in the `occurances`, it will not re-calculated.
# Thus, the bigO is propotional to the number of values calculated.
# For each number, we will divide the value into two parts. The first part
# can be considered as decrementing highest number until the length of the
# number is shortened to 1; while the second part is the remainder from the
# first part and is also calculated in the same way as first part.
#
# So the total number calculated is k * l * 2, where `k` is the hightest digit,
# and `l` is the length of the number, and `2` is from two parts.
#
# The bigO will be O(k * l), since `k` is at most 10 numbers, the bigO is O(l)


class LuckySevenFinder
  def initialize
    @occurances  = {}
  end

  def calculate(n)
    num_7(n)
  end

  private

  def num_7(n)

    if v = value_from_termination_condition(n)
      return v
    end

    return @occurances[n] if @occurances[n]

    # Assume n = 829, then t0 = 100, t1 = 800
    t0 = 10.pow( Math.log(n, 10).to_i )
    t1 = (n/t0) * t0

    s0 = num_7(t1-1)
    s1 = if t1 / t0 == 7
           (n % t0) + 1
         else
           num_7(n % t0)
         end

    @occurances[n] = s0 + s1
    @occurances[n]
  end

  def value_from_termination_condition(n)
    # if only one digit now, we can just check
    if n.between?(0, 6)
      return 0
    elsif n.between?(7, 9)
      return 1
    end

    nil
  end
end

def self_test
  puts '+++++ Perform algorithm self testing +++++'
  finder = LuckySevenFinder.new

  cache = {}
  cache[0] = 0

  # use simple algorithm to test our algorithm correctness
  (1..100000).each do |n|
    cache[n] = if n.to_s.include?('7')
                 cache[n-1] + 1
               else
                 cache[n-1]
               end
    ours = finder.calculate(n)

    if cache[n] != ours
      raise "For N=#{n}: Correct: #{cache[n]}, Algorithm: #{ours}"
    end
  end

  puts '+++++ Algorithm test completes +++++'
end

self_test

puts "Please input a number"
n = gets.to_i

finder = LuckySevenFinder.new
puts "num 7: #{finder.calculate(n)}"
