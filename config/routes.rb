Zhengquan::Application.routes.draw do
  resources :snips

  resources :stores,:path=>'yyb' do
    collection do 
      get 'dirty'
    end
  end
  provinces = Regexp.new(Province.pluck(:name_en).join('|')) rescue nil
  match '/:province/:id' => 'stores#province_company',:as=>'province_company',:constraints=>{:province => provinces}
  match '/:province' => 'stores#province',:as=>'province',:constraints=>{:province => provinces}

  get 'companies/versions'=>'companies#recent_versions',as: "versions"
  resources :companies,:except=>[:index]

  #authenticated :user do
    #root :to => 'home#index'
  #end
  #match '/companies/:id'=>'companies#city',:as=>'company_city'
  root :to => "companies#home"
  devise_for :users
  resources :users
  #get '/:id'=>'companies#show'
  get '/:id/yyb'=>'companies#yyb',:as=>'company_stores'
  get '/:id/versions'=>'companies#versions',:as=>'company_versions'
  #get '/:id/version/:number'=>'companies#version',:as=>'company_version'
  get '/:id'=>'companies#show',:as=>'company_home'
end
