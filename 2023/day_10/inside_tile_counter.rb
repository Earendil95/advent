# frozen_string_literal: true

# :nodoc:
class InsideTileCounter
  FLIPPING_CORNERS = { 'L' => '7', 'F' => 'J' }.freeze

  attr_reader :map, :border

  def initialize(map, border)
    @map = map
    @border = border
    @inside = false
    @last_corner_was = nil
  end

  def count
    count = 0

    map.each_with_index do |tile, i, j|
      if border.include?([i, j])
        determine_inside_flag!(tile)
        next
      end

      count += 1 if @inside
    end

    count
  end

  private

  def determine_inside_flag!(tile)
    return if tile.type == '-' # nothing happens if we're going along the border
    return @inside = !@inside if tile.type == '|' # if the border is | we definitely cross it

    # now two options:
    # 1. The border was going like L---7 or F---J. In this case, we cross it as soon as we pass the right part and
    #    should change the @inside var
    # 2. The border was going like L---J or F---7. In this case, we did not cross it and don't need to change anything
    if %w[L F].include?(tile.type)
      @last_corner_was = tile.type
    else
      @inside = !@inside if tile.type == FLIPPING_CORNERS.fetch(@last_corner_was)
      @last_corner_was = nil
    end
  end
end
