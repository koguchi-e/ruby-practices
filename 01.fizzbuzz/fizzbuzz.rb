array = (1..20).to_a

def fizz_buzz(numbers)
  numbers.each do |a|
    if a % 5 == 0 && a % 3 == 0
      puts "FizzBuzz"
    elsif a % 3 == 0
      puts "Fizz"
    elsif a % 5 == 0
      puts "Buzz"
    else
      puts a
    end
  end
end

p fizz_buzz(array)
