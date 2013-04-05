#encoding: utf-8
require 'spec_helper'

describe Company do
  it "should import_from_sac" do
    #Company.import_from_sac
    #pp Company.count
    #Company.import_all_stores
    #pp Store.count
    #pp Company.first
  end
  it "should import_stores" do
    #c = Company.create :name => '东海证券有限责任公司',:oid=>3796
    #c.import_stores
    #pp c.stores
  end
  it "should gen slug" do
    c = Company.create :name=>'国海证券有限责任公司'
    c.slug.should be_eql('ghzq')
    c = Company.create :name=>'国海证券有限责任公司'
    c.slug.should be_eql('ghzq2')
  end
end

