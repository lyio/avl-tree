require_relative 'avl.rb'

tree = AvlTree.new
File.open("Daten2A.txt", "r") do |infile|
  while line = infile.gets
    line.split.each do |n|
      puts '#########################'
      puts "adding #{n} to tree"
      tree.add(n.to_i)
      puts '#########################'
    end
  end
end

puts "#{tree.root}"
puts "tree contains: #{tree.nodes_inorder.length} nodes"

k = 235
puts "deleting key #{k} from tree"
tree.remove k
puts "tree contains: #{tree.nodes_inorder.length} nodes"
