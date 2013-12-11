class Snip < ActiveRecord::Base
  attr_accessible :body, :name
  def self.output name
    find_by_name(name).body rescue ""
  end
end
