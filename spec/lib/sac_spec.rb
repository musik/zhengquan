#encoding: utf-8
require 'spec_helper'

describe Sac do
  it "should fetch companies" do
    #pp Sac.item(3796).as_json["table"]
    #pp Sac.item(3796).hash
    #pp Company.create(Sac.item(3796).hash)
    #pp c
    #Sac.run
  end
  it "should gen slug" do
    #shorts = []
    #Sac.companies.each do |c|
      #shorts << c.short
      #next if c.slug.nil?
      #expect(c.slug).to match(/^[0-9a-z\-]+$/)
      ##pp [c.slug,c.oid,c.website] if c.slug.match(/^[0-9a-z\-]+$/).nil?
    #end
    #expect(shorts.size).to eql(shorts.uniq.size)
  end
  it "should fetch yingyebu" do
    Sac.yingyebu(3796)
  end
end

