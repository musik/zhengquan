#encoding: utf-8
class Company < ActiveRecord::Base
  attr_accessible :address, :address1, :capital, :contact, :email, :name, :oid, :phone, :postal, :scopes, :sn, :website, :slug,:pinyin,:abbr,:short,:city_id,:content,:letter,:vn
  belongs_to :city,:counter_cache=>true
  has_many :stores
  scope :large,order('stores_count desc')
  before_create :slug_gen

  versioned
  def to_short
    name.sub(/(股份|经纪)*有限.*公司/,'')
  end
  def to_param 
    slug
  end
  def to_url
    "/" + slug
  end
  def city_name
    city.present? ? city.short_name : nil
  end

  def self.scopes
    pluck(:scopes).join('；').gsub(/。/,'').split('；').uniq
  end
  def self.import_from_sac
    Sac.companies.each do |c|
      next if exists?(:oid=>c.oid)
      create c.hash
    end
  end
  def self.import_all_stores
    all.each do |c|
      c.import_stores
    end
  end
  def import_stores
    Sac.yingyebu(oid).each do |yyb|
      next if stores.exists? :name=>yyb.name
      stores.create yyb.hash
    end
  end
  private
  def slug_gen
    pinyin = Pinyin.t(name)
    self[:short] = to_short if short.nil?
    self[:pinyin] = Pinyin.t(name,'')
    self[:abbr] = Pinyin.abbr(name)
    self[:letter] = self[:abbr][0]

    base_slug = slug.present? ? slug : Pinyin.abbr(short)
    tmp = base_slug
    i = 1
    while self.class.exists?(:slug=>tmp) do
      i+=1
      tmp = base_slug + i.to_s
    end
    self[:slug] = tmp

    self
  end
end
