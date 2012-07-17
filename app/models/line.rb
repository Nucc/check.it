
class Line

  PLUS              = 1
  MINUS             = 2
  NOCHANGE          = 3

  include ActiveModel::AttributeMethods
  extend ActiveModel::Naming

  attr_reader   :plus
  attr_reader   :minus
  attr_reader   :content
  attr_reader   :type
  attr_accessor :num

  def initialize(plain_line)
    if plain_line.match /^\+/
      @type    = PLUS
      @content = "+ " + plain_line.match(/^\+(.*)/)[1]
    elsif plain_line.match /^\-/
      @type    = MINUS
      @content = "- " + plain_line.match(/^\-(.*)/)[1]
    else
      @type =   NOCHANGE
      @content = " " + plain_line
    end
  end

  def set_number(plus, minus)
    if @type == PLUS
      plus += 1
      @minus = minus
      @plus = plus
    elsif @type == MINUS
      minus += 1
      @minus = minus
      @plus  = plus
    elsif @type == NOCHANGE
      plus  += 1
      minus += 1
      @plus  = plus
      @minus = minus
    end

    return [plus, minus]
  end

  def minus?
    @type != PLUS
  end

  def plus?
    @type != MINUS
  end


  def content
    @content || ""
  end
end
