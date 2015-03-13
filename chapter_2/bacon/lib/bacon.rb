class Bacon
  attr_accessor :expired

  def edible?
    !expired
  end

  def expired!
    self.expired = true
  end
end