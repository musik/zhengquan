#encoding: utf-8
require 'typhoeus'
require 'nokogiri'
require 'ostruct'
#require 'chinese_cities'
require 'pp'
module Sac
  class << self
    def run
      @links = list
      @links.each do |id|
         item(id)
         break
      end
    end
    def logos
      response = Typhoeus::Request.get('http://www.sac.net.cn/wlzf/hfjgxxgs/')
      doc = Nokogiri::HTML(response.body)
      doc.css('a.zf_hui12').each do |a|
        next if a.at_css('img').nil?
        slug = a.attr('href').downcase.match(/http:\/\/(?:www\.)*([^.]+)/)[1] rescue nil
        puts "wget http://www.sac.net.cn/wlzf/hfjgxxgs/" + a.at_css('img').attr("src").sub('./','') + " -O #{slug}.jpg"
      end
    end
    def companies
      @links = list
      @companies = []
      @links.each do |id|
        @companies << item(id)
      end
      @companies.compact
    end
    def list
      @links ||= begin
        response = Typhoeus::Request.get('http://cx.sac.net.cn/huiyuan/g/cn/cx/z.jsp?m_type=zqgs')  
        doc = Nokogiri::HTML(response.body.encode('UTF-8','GBK'))
        links = []
        doc.css('.deep a').each do |link|
          links << link.attr('href').match(/id\=(\d+)/)[1]
        end
        links.uniq
      end
    end
    def item id
      url = "http://cx.sac.net.cn/huiyuan/g/cn/cx/zqgs_home.jsp?id=#{id}"
      response = Typhoeus::Request.get(url)  
      doc = Nokogiri::HTML(response.body.encode('UTF-8','GBK'))
      data = {'oid' => id.to_i}
      c1 = doc.at_css('#content1')
      size = c1.css('td').size
      Range.new(0,size/2-1).each do |i|
        key = c1.css('td')[i*2].text.strip
        val = c1.css('td')[i*2+1].text.strip
        next if key !~ /[^[:space:]]/
        data[key] = val
      end
      Company.import data
    end
    def yingyebu id
      url = "http://cx.sac.net.cn/huiyuan/g/cn/cx/zqgs_home.jsp?id=#{id}"
      response = Typhoeus::Request.get(url)  
      doc = Nokogiri::HTML(response.body.encode('UTF-8','GBK'))
      data = {'oid' => id.to_i}
      c1 = doc.at_css('#content2')
      results = []
      i = 0
      c1.css('tr').each do |tr|
        i+=1
        next if i < 3
        arr = []
        tr.css('td').each do |td|
          arr << td.text.strip
        end
        results << Yyb.new(arr)
      end
      results
    end
  end
  class Yyb < OpenStruct
    def initialize arr
      keys = %w(name address contact location phone email tousu)
      tmp = {}
      keys.each_index do |i|
        tmp[keys[i]] = arr[i]
      end
      super tmp
      convert_types
      self
    end
    def convert_types
      self.email.gsub!(/ /,'')
      #str = address.match(/(.{2}|)..市/)
      #str = str.nil? ? address.sub("中国",'')[0,2] + "市" : str.to_s
      #arr = str.length > 3 ? [str[2,3],str[1,4],str] : [str]
      #city = City.find_by_names(arr)
      #self.city_id = city.id if city.present?
      #pp [str,address] if city.nil?
      city = City.detect address
      if city.present?
        self.city_id = city.id
        self.province_id = city.province_id
      else
        province = Province.search_by_short(location)
        self.province_id = province.id if province.present?
        if province.nil?
          pp [Province.detect(address),address]
        end
      end
    end
    def hash
      hash = as_json["table"]
      hash.delete :location
      hash
    end
  end
  class Company < OpenStruct
      def initialize data={}
        super data
        convert_types
      end
      def convert_types
        self.short = name.sub(/(股份|经纪)*有限.*公司/,'')

        if website != '无'
          self.website.downcase!
          self.website.gsub!(/[：；]/,'')
          self.website.gsub!("http//",'http://')
          self.website.gsub!(/^http:\/\/ /,'http://')
          self.website.gsub!(/^http:\\\\/,'http://')
          self.website = "http://" + website if website.match(/^http:\/\//).nil?
          self.slug = website.match(/http:\/\/(?:www\.)*([^.]+)/)[1] rescue nil
        end
        if address.present? 
          str = address.match(/(.{2}|)..市/)
          #str = address.sub("闹市",'').match(/(.{2}|)..市/)
          str = str.nil? ? address.sub("中国",'')[0,2] + "市" : str.to_s
          #if defined?(City).present?
            arr = str.length > 3 ? [str[2,3],str[1,4],str] : [str]
            self.city = City.find_by_names(arr)
          #end
        end
      end
      def hash
        self.city_id = city.id if city.present?
        hash = as_json["table"]
        hash.delete(:city)
        hash
      end
     def self.import data
        keys = {
          :oid => 'oid',
          :name => '中文全称',
          :address1 => '办公地址',
          :address => '注册地',
          :contact => '法定代表人',
          :sn =>'经营证券业务许可证编号',
          :capital =>'注册资本',
          :postal =>'办公地址邮码',
          :email =>'公司电子邮箱',
          :phone =>'客户服务或投诉电话',
          :website =>'公司网址　',
          :scopes =>'已经获相关业务资格',

        }
        hash = {} 
        keys.each do |k,v|
          hash[k] = data[v]
        end
        return nil if hash[:address].blank?
        self.new(hash)
     end
  end
end
