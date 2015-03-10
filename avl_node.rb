class AvlNode
  attr_accessor :left, :right, :balance, :value, :parent

  def initialize(k)
    @left = nil
    @right = nil
    @parent = nil
    @balance = 0
    @value = k
  end

  def to_s
    "{Value: #{@value} | balance: #{@balance} left: #{@left} | right: #{@right}}"
  end
end
