def bad_two_sum?(ary, target_sum)

  i = 0
  while i < ary.length
    j = i + 1

    while j < ary.length
      return true if ary[i] + ary[j] == target_sum

      j += 1
    end

    i += 1
  end

  false
end

def okay_two_sum?(ary, target_sum)
  sorted_ary = ary.sort

  sorted_ary.each_with_index do |el, index|
    searched_index = bsearch(sorted_ary, target_sum - el)
    return true if searched_index && searched_index != index
  end

  false
end

def two_sum?(ary, target_sum)
  nums_hash = Hash.new
  ary.each do |el|
    return true if nums_hash.key?(target_sum - el)
    nums_hash[el] = nil
  end

  false
end

def qsort(ary)
  return ary if ary.length <= 1
  pivot = ary.delete_at(rand(ary.length))
  left, right = ary.permutation { |el| el < pivot }
  qsort(left) + pivot + qsort(right)
end

def bsearch(ary, target)
  return false if ary.empty?
  pivot = ary.length / 2
  return pivot if ary[pivot] == target
  left, right = ary.take(pivot), ary.drop(pivot + 1)

  if ary[pivot] > target
    bsearch(left, target)
  else
    subindex = bsearch(right, target)
    return false if subindex == false
    subindex += pivot + 1
  end
end


if __FILE__ == $PROGRAM_NAME
  arr = [0, 1, 5, 7]
  p two_sum?(arr, 6) # => should be true
  p two_sum?(arr, 10) # => should be false

end
