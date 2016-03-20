def windowed_max_range(array, window_size)
  i = 0
  current_max_range = 0

  while i <= array.length - window_size
    window = array[i..i + window_size - 1]
    window_range = window.max - window.min
    if current_max_range < window_range
      current_max_range = window_range
    end

    i += 1
  end

  current_max_range
end

if __FILE__ == $PROGRAM_NAME
  arr = [0, 1, 5, 7]
  p windowed_max_range([1, 0, 2, 5, 4, 8], 2) #== 4 # 4, 8
  p windowed_max_range([1, 0, 2, 5, 4, 8], 3) #== 5 # 0, 2, 5
  p windowed_max_range([1, 0, 2, 5, 4, 8], 4) #== 6 # 2, 5, 4, 8
  p windowed_max_range([1, 3, 2, 5, 4, 8], 5) #== 6 # 3, 2, 5, 4, 8

end

class MyQueue
  def initialize
    @store = []
  end

  def enqueue(value)
    @store.push(value)
  end

  def dequeue
    @store.shift
  end

  def peek
    @store.first
  end

  def empty?
    @store.empty?
  end
end

class MyStack
  def initialize
    @store = []
    @val_hash = {}
    @min = nil
    @max = nil
  end

  def push(value)
    @store.push(value)
    @val_hash[value] = nil
    @min = @val_hash.select { |k,v| k.min } if value <= @min
    @max = @val_hash.select { |k,v| k.max } if value >= @max
  end

  def pop
    result = @store.pop
    @val_hash.delete(result)
    @min = @val_hash.select { |k,v| k.min } unless result == @min
    @max = @val_hash.select { |k,v| k.max } unless result == @max
    result
  end

  def peek
    @store.last
  end

  def empty?
    @store.empty?
  end

  def max
    @max
  end

  def min
    @min
  end
end

class StackQueue
  def initialize
    @stack1 = Stack.new
    @stack2 = Stack.new
  end

  def enqueue(value)
    @stack1.push(value)
  end

  def dequeue
    until @stack1.empty?
      @stack2.push(@stack1.pop)
    end

    result = @stack2.pop

    until @stack2.empty?
      @stack1.push(@stack2.pop)
    end

    result
  end

  def peek
    until @stack1.empty?
      @stack2.push(@stack1.pop)
    end

    result = @stack2.peek

    until @stack2.empty?
      @stack1.push(@stack2.pop)
    end

    result
  end

  def empty?
   @stack1.empty?
  end
end
