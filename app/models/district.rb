# encoding: utf-8

class District < ActiveRecord::Base
  extend LocationEx

  attr_accessible :name, :city_id, :name_en, :name_abbr

  belongs_to :city

  scope :with_city, ->(city) { where(city_id: city) }

  def province
    city.province
  end

  def short_name
    @short_name ||= name.gsub(/区|县|市|自治县/, '')
  end

  def siblings
    @siblings ||= scoped.with_city(self.city_id)
  end

  def self.test_names
    Province.all.each do |province|
      pp names province
    end
    nil
  end
  def self.names province
    @names ||= {}
    @names[province.id] ||= 
      begin
        names = province.districts.pluck('districts.name').collect{|str| str[0,2]}
        names.delete_if{|e| names.count(e) > 1}
        names
      end
  end
  def self.detect address,province
    patt = Regexp.new(names(province).join('|'))
    match = address.match(patt)
    match.nil? ? nil : province.districts.search_by_short(match.to_s)
    #match.nil? ? nil : province.districts.find_by_name(match.to_s)
  end

end
