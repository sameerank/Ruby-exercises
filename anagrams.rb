def first_anagram?(str_1, str_2)
  letters_str1 = str_1.split("")

  lettersets = letters_str1.permutation.to_a
  anagrams = lettersets.map { |letter_set| letter_set.join }

  anagrams.include?(str_2)
end

def second_anagram?(str_1, str_2)
  letters_str1, letters_str2 = str_1.split(""), str_2.split("")

  letters_str1.each_index do |i|
    deleted = false
    letters_str2.each_index do |j|
      if letters_str1[i] == letters_str2[j]
        letters_str1.delete_at(i)
        letters_str2.delete_at(j)
        deleted = true
      end
    end

    redo if deleted
  end

  return true if letters_str1.empty? && letters_str2.empty?
  false

end

def third_anagram?(str_1, str_2)
  letters_str1, letters_str2 = str_1.split(""), str_2.split("")
  sorted_letter_set1, sorted_letter_set2 = letters_str1.sort, letters_str2.sort

  sorted_letter_set1 == sorted_letter_set2
end

def fourth_anagram?(str_1, str_2)
  letter_set = Hash.new(0)

  str_1.each_char { |letter| letter_set[letter] += 1 }
  str_2.each_char { |letter| letter_set[letter] -= 1 }

  letter_set.values.all? { |el| el.zero? }
end

def subsets(letters)
  return [letters] if letters.length <= 1
  smaller_letter_set = subsets(letters.take(letters.length - 1))
  larger_letter_set = []
  smaller_letter_set.each { |letter_set| larger_letter_set << letter_set + [letters.last] }
  smaller_letter_set + larger_letter_set
end

if __FILE__ == $PROGRAM_NAME
  puts fourth_anagram?("gizmo", "sally")    #=> false
  puts fourth_anagram?("elvis", "lives")
end
