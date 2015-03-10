require_relative 'avl_node.rb'

class AvlTree
  attr_accessor :root

  def initialize
    @root = nil # root node
  end

  def to_s
    "#{@root}"
  end

  # Add a new element with value "k" into the tree.
  def add(k)
    # create new node
    n = AvlNode.new k
    # start recursive procedure for inserting the node
    insert_avl(@root, n)
  end

  # Removes a node from the tree, if it is existent.
  def remove(k)
    #First we must find the node, after this we can delete it.
    remove_avl(@root, k);
  end

  # Calculates the Inorder traversal of this tree.
  # @return array of the nodes in the tree in inorder traversal.
  def nodes_inorder
    ret = []
    inorder(root, ret)
    ret
  end

  private
  # Recursive method to insert a node into a tree.
  #@param node The node currently compared, usually you start with the root.
  #@param new_node The node to be inserted.
  def insert_avl(node, new_node)
    #no node exists yet, inserting new node as root
    if node.nil?
      @root=new_node
    else
      # traversing left subtree
      if new_node.value < node.value
        if node.left.nil?
          node.left = new_node
          new_node.parent = node
          # rebalancing after insertion
          recursive_balance(node)
        else
          # recurse further down the left subtree
          insert_avl(node.left, new_node)
        end
        # continue with right side
      else
        if new_node.value > node.value
          if node.right.nil?
            node.right = new_node
            new_node.parent = node
            # rebalance after insertion
            recursive_balance(node)
          else
            # recurse further down right subtree
            insert_avl(node.right, new_node)
          end
        end
      end
    end
  end

  # Check the balance for each node recursively and call required methods for balancing the tree until the root is reached.
  # @param current_node : The node to check the balance for, usually you start with the parent of a leaf.
  def recursive_balance(current_node)
    balance = update_balance(current_node)

    # check the balance
    case balance
      when -2
        current_node = (height(current_node.left.left) >= height(current_node.left.right)) ? rotate_right(current_node) : double_rotate_left_right(current_node)
      when 2
        current_node = (height(current_node.right.right) >= height(current_node.right.left)) ? rotate_left(current_node) : double_rotate_right_left(current_node)
    end

    # traverse upwards until root
    if current_node.parent.nil?
      @root = current_node;
    else
      recursive_balance(current_node.parent);
    end
  end


  # Finds a node and calls a method to remove the node.
  def remove_avl(node, value)
    # value doesn't exist in tree
    unless node.nil?
      remove_avl(node.left, value) if node.value > value
      remove_avl(node.right, value) if node.value < value
      remove_found_node(node) if (node.value == value)
    end
  end

  # Removes a node from a AVL-Tree, while balancing will be done if necessary.
  def remove_found_node(node)
    #at most one child of new_node, new_node will be removed directly
    if node.left.nil? or node.right.nil?
      #the root is deleted
      if node.parent.nil?
        @root=nil
        node=nil
        return
      end
      r = node
    else
      # new_node has two children --> will be replaced by successor
      r = successor(node)
      node.value = r.value
    end

    if r.left.nil?
      p = r.right;
    else
      p = r.left;
    end

    unless p.nil?
      p.parent = r.parent;
    end
    if r.parent.nil?
      this.root = p;
    else
      if r==r.parent.left
        r.parent.left=p;
      else
        r.parent.right = p
        # balancing must be done until the root is reached.
        recursive_balance(r.parent)
      end
    end
    r = nil
  end

  #Left rotation using the given node.
  # @param node The node for the rotation.
  # @return The root of the rotated tree.
  def rotate_left(node)
    v = node.right
    v.parent = node.parent
    node.right = v.left

    node.right.parent=node unless node.right.nil?

    v.left = node
    node.parent = v

    unless v.parent.nil?
      v.parent.right = v if v.parent.right==node
      v.parent.left = v if v.parent.left==node
    end

    update_balance(node)
    update_balance(v)
    v
  end

  # Right rotation using the given node.
  # @param node The node for the rotation
  # @return The root of the new rotated tree.
  def rotate_right(node)
    v = node.left
    v.parent = node.parent
    node.left = v.right

    node.left.parent=node unless node.left.nil?

    v.right = node
    node.parent = v

    unless v.parent.nil?
      v.parent.right = v if v.parent.right==node
      v.parent.left = v if v.parent.left==node
    end

    update_balance(node)
    update_balance(v)
    v
  end

  #@param u The node for the rotation.
  # @return The root after the double rotation.
  def double_rotate_left_right(u)
    u.left = rotate_left u.left
    rotate_right u
  end

  def double_rotate_right_left(u)
    u.right = rotate_right u.right
    rotate_left u
  end

  # Returns the successor of a given node in the tree (search recursivly).
  # @param q The predecessor.
  # @return The successor of node q.
  def successor(q)
    if q.right.nil?
      p = q.parent
      while not p.nil? and q==p.right
        q = p
        p = q.parent
      end
      p
    else
      r = q.right
      until r.left.nil?
        r = r.left
      end
      r
    end
  end

  #* Calculating the "height" of a node.
  # @param current_node
  # @return The height of a node (-1, if node is not existent eg. NULL).
  def height(current_node)
    #node doesn't exist
    return -1 if current_node.nil?

    if current_node.left.nil? and current_node.right.nil?
      0
    else
      if current_node.left.nil?
        return 1+height(current_node.right);
      else
        if current_node.right.nil?
          return 1+height(current_node.left);
        else
          return 1+maximum(height(current_node.left), height(current_node.right));
        end
      end
    end
  end


  # Return the maximum of two integers.
  def maximum(a, b)
    (a >= b) ? a : b
  end

  def update_balance(cur)
    cur.balance = height(cur.right)-height(cur.left)
    cur.balance
  end


  #Function to calculate inorder recursivly.
  #@param n The current node.
  #@param io The list to save the inorder traversal.
  def inorder(n, io)
    unless n.nil?
      inorder(n.left, io)
      io.push(n)
      inorder(n.right, io)
    end
  end
 end
