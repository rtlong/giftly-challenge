class NavigationElement
  def initialize(text, target)
    @text, @target = text, target
  end

  attr_reader :text, :target
end
