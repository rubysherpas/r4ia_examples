class State < ActiveRecord::Base
  def self.default
    find_by(default: true)
  end

  def make_default!
    State.update_all(default: false)
    update!(default: true)
  end

  def to_s
    name
  end
end
