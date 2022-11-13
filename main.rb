class Machine < Struct.new(:statement, :environment)
  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def run
    while statement.reducible?
      puts "#{statement}, #{environment}"
      step
    end
    puts "#{statement}, #{environment}"

  end
end

class Number < Struct.new(:value)
  def reducible?
    false
  end

  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end
end

class Boolean < Struct.new(:value)
  def reducible?
    false
  end

  def to_s
    value.to_s
  end

  def inspect
    "«#{self}»"
  end
end

class Add < Struct.new(:left, :right)
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Add.new(left.reduce(environment), right)
    elsif right.reducible?
      Add.new(left, right.reduce(environment))
    else
      Number.new(left.value + right.value)
    end
  end

  def to_s
    "#{left} + #{right}"
  end

  def inspect
    "«#{self}»"
  end
end

class Multiply < Struct.new(:left, :right)
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      Multiply.new(left.reduce(environment), right)
    elsif right.reducible?
      Multply.new(left, right.reduce(environment))
    else
      Number.new(left.value * right.value)
    end
  end

  def to_s
    "#{left} * #{right}"
  end

  def inspect
    "«#{self}»"
  end
end

class LessThan < Struct.new(:left, :right)
  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      LessThan.new(left.reduce(environment), right)
    elsif right.reducible?
      LessThan.new(left, right.reduce(environment))
    else
      Boolean.new(left.value < right.value)
    end
  end

  def to_s
    "#{left} < #{right}"
  end

  def inspect
    "«#{self}»"
  end
end

class Variable < Struct.new(:name)
  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end

  def to_s
    name.to_s
  end

  def inspect
    "«#{self}»"
  end
end


# Statements
class DoNothing
  def reducible?
    false
  end

  def ==(other_statement)
    other_statement_instance_of?(DoNothing)
  end

  def to_s
    'do-nothing'
  end

  def inspect
    "«#{self}»"
  end
end

class Assign < Struct.new(:name, :expression)
  def reducible?
    true
  end

  def reduce(environment)
    if expression.reducible?
      [Assign.new(name, expression.reduce(environment)), environment]
    else
      [DoNothing.new, environment.merge({ name => expression })]
    end
  end

  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "«#{self}»"
  end
end
