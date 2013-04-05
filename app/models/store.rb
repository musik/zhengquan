#encoding: utf-8
class Store < ActiveRecord::Base
  belongs_to :company,:counter_cache=>true
  belongs_to :city
  belongs_to :province
  attr_accessible :address, :contact, :email, :name, :phone, :tousu, :city_id, :province_id,:district_id

  scope :city_null,where(:city_id=>nil)
  scope :province_null,where(:province_id=>nil)
  def short_name
    name.sub(company.name,'')
  end

  def city_name
    @city_name ||= 
      begin
        arr = []
        arr << province.name if province.present?
        arr << city.name if province.present?
        arr.uniq.join(' - ')
      end
  end
  class Fixer
    def self.fix_provinces
      Store.province_null.where('city_id > 0').includes(:city).each do |s|
        s.update_attribute :province_id,s.city.province.id
      end
      Store.province_null.each do |s|
        province = Province.detect s.address
        s.update_attribute :province_id,province.id if province.present?
      end
      nil
    end
    def self.fix_cities
      Store.city_null.each do |s|
        city = City.detect s.address
        s.update_attribute :city_id,city.id if city.present?
      end
      nil
    end
    def self.fix_districts
      i = 0
      outputs = {:str=>[],:province=>[],:size=>[],:success=>[]}
      Store.city_null.each do |s|
        address = s.address.gsub('自冶','自治').gsub('涿洲','涿州')
        str = address.sub('新疆维吾尔自治区','').match(/(.{2})(浩特市|满族自治县|市|县|区)/)
        if str.nil?
          outputs[:str] << s.address
          next
        end
        if s.province_id.nil?
          outputs[:province] << [str,s.address]
        else
          diss = s.province.districts.all_by_short str[1]
          if diss.size > 1
            diss = s.province.districts.all_by_short str[1]+str[2]
            if diss.size > 1
              outputs[:size] << [str[0],s.address,diss]
            end
          end
          if diss.size == 1
            dis = diss.first
            i+=1
            s.update_attributes({:district_id=>dis.id, :city_id => dis.city.id})
          end
        end
      end
      outputs.each do |ss|
        ss.each do |s|
          pp s
        end
      end
      pp Store.city_null.count
      pp i
      nil
    end
    def self.detect_districts
      Store.city_null.includes(:province).each do |s|
        next if s.province.nil?
        dis = District.detect s.address,s.province
        next if dis.nil?
        s.update_attributes({:district_id=>dis.id, :city_id => dis.city.id})
      end
      nil
    end
  end
end
