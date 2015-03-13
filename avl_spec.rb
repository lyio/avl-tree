require 'rspec'
require_relative 'avl_tree.rb'
require_relative 'avl.rb'

describe 'AvlNode insert' do
  it 'should be correct for three left nodes' do
    tree = AvlTree.new
    tree.add(3)
    tree.add(2)
    tree.add(1)
    tree.root.value.should === 2
  end

  it 'should be correct for three right nodes' do
    tree = AvlTree.new
    tree.add(3)
    tree.add(4)
    tree.add(5)
    tree.root.value.should === 4
  end

  it 'should correctly build tree from wikipedia' do
    tree = AvlTree.new
    tree.add 50
    tree.add 17
    tree.add 72
    tree.add 12
    tree.add 76
    tree.add 23
    tree.add 14
    tree.add 54
    tree.add 19
    tree.add 67
    tree.add 9

    tree.root.value.should === 50
    tree.root.right.right.value.should === 76
  end

  it 'should be correct as by example' do
    tree = AvlTree.new
    tree.add(3)
    tree.add(2)
    tree.add(1)
    tree.add(4)
    tree.add(5)
    tree.add(6)
    tree.add(7)
    tree.add(15)
    tree.add(16)

    tree.root.value.should === 4
    tree.root.right.right.value.should === 15
  end
end

describe 'AvlNode remove_node' do
  it 'should correctly remove left node without children' do
    tree = AvlTree.new
    tree.add(3)
    tree.add(4)
    tree.add(1)

    tree.remove(1)
    tree.root.left.should === nil
    tree.root.right.value.should === 4
  end

  it 'should correctly remove left node' do
    tree = AvlTree.new
    tree.add(3)
    tree.add(2)
    tree.add(1)

    tree.remove(1)
    tree.root.right.value.should === 3
    tree.root.left.should === nil
  end

  it 'should correctly remove node and rebalance tree' do
    tree = AvlTree.new
    tree.add(3)
    tree.add(4)
    tree.add(1)
    tree.add 5

    tree.remove 1
    puts tree.root
    tree.root.value.should === 4
    tree.nodes_inorder.length.should === 3
    end
end
