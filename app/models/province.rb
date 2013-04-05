# encoding: utf-8

class Province < ActiveRecord::Base
  extend LocationEx

  attr_accessible :name, :name_en, :name_abbr
  
  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities
  has_many :companies, through: :cities
  has_many :stores
  scope :quick,select('name,name_en,name_abbr')
  def self.neidi
    results = Province.quick.all
    results.delete_if{|r| %w(xianggang aomen taiwan).include? r.name_en}
    results
  end
  def short_name
    @short_name ||= name.gsub(/市|省|特别行政区|回族自治区|维吾尔自治区|壮族自治区|自治区/, '')
  end
  def self.names
    pluck(:name).collect{|str| str[0,2]}
  end
  def self.detect address
    patt = Regexp.new(names.join("|"))
    match = address.match(patt)
    match.nil? ? nil : search_by_short(match.to_s)
  end
end
