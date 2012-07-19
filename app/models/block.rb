class Block
  include ActiveModel::AttributeMethods
  extend ActiveModel::Naming

  attr_accessor :number
  attr_reader   :lines
  attr_accessor :filename

  attr_reader   :size_info

  def initialize
    @empty = true
    @lines = []

    @plus  = 0
    @minus = 0

    @length_plus  = -1
    @length_minus = -1

    @size_info = nil
  end

  def parse(plain_line)

    return false if @plus == @length_plus and @minus == @length_minus

    if plain_line.match /^@@ (.*)/

      patch_info = plain_line.match(/^@@ \-(\d*)(,(\d*)){0,1} \+(\d*)(,(\d*)){0,1}/)

      @plus   = patch_info[4].to_i - 1
      @minus  = patch_info[1].to_i - 1

      @length_plus  = @plus  + (patch_info[6] || 1).to_i
      @length_minus = @minus + (patch_info[3] || 1).to_i

      @size_info = plain_line
      return true
    end

    if (@size_info)
      line = Line.new(plain_line)
      @plus, @minus = line.set_number @plus, @minus
      @lines << line
    end

    return true
  end

end
