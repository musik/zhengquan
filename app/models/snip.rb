class Snip < ActiveRecord::Base
  attr_accessible :body, :name
  def self.output name
    RedCloth.new(find_by_name(name).body).to_html rescue nil
  end
end
