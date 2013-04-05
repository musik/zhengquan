# encoding: utf-8

class City < ActiveRecord::Base
  extend LocationEx
  
  attr_accessible :name, :province_id, :level, :zip_code, :name_en, :name_abbr
  
  belongs_to :province
  has_many :districts, dependent: :destroy
  has_many :companies
  has_many :stores

  scope :with_province, ->(province) { where(province_id: province) }
  scope :top, order("companies_count desc")
  scope :not_empty, where("companies_count != 0")

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/, '')
  end

  def siblings
    @siblings ||= scoped.with_province(self.province_id)
  end

  def self.find_by_names arr
    where(:name=>arr).first
  end
  def self.names
    pluck(:name).collect{|str| str[0,2]} - %w(张家 阿拉) + %w(张家口 张家界 阿拉善 阿拉尔)
  end
  def self.detect address
    cities_patt = Regexp.new(names.join('|'))
    match = address.match(cities_patt)
    match.nil? ? nil : search_by_short(match.to_s)
  end

end
