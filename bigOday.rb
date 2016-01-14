require 'byebug'

def my_min(ary)
  min_num = nil
  ary.each do |el1|
    if ary.all? { |el2| el1 <= el2 }
      min_num = el1
    end
  end
  min_num
end

def better_my_min(ary)
  min_num = ary.first
  ary.drop(1).each { |el| min_num = el if el < min_num }
  min_num
end

def largest_contig_sum(list)
  sub_arys = subsets(list)
  sub_arys.map { |ary| ary.inject(:+) }.max
end

def subsets(ary)
  res = []
  i = 0
  while i < ary.length
    res << [ary[i]]
    ary.drop(i+1).each do |el|
      res = res + [res.last + [el]]
    end

    i +=1
  end
  res
end

def better_largest_contig_sum(list)
  largest, contig_sum = 0, 0
  list.each do |el|
    if el < 0
      contig_sum = 0
    else
      contig_sum += el
      largest = contig_sum if largest < contig_sum
    end
  end

  largest
end

if __FILE__ == $PROGRAM_NAME
  list = [ 0, 3, 5, 4, -5, 10, 1, 90 ]
  puts my_min(list)
  puts better_my_min(list)
end
