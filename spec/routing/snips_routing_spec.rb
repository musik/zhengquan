require "spec_helper"

describe SnipsController do
  describe "routing" do

    it "routes to #index" do
      get("/snips").should route_to("snips#index")
    end

    it "routes to #new" do
      get("/snips/new").should route_to("snips#new")
    end

    it "routes to #show" do
      get("/snips/1").should route_to("snips#show", :id => "1")
    end

    it "routes to #edit" do
      get("/snips/1/edit").should route_to("snips#edit", :id => "1")
    end

    it "routes to #create" do
      post("/snips").should route_to("snips#create")
    end

    it "routes to #update" do
      put("/snips/1").should route_to("snips#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/snips/1").should route_to("snips#destroy", :id => "1")
    end

  end
end
