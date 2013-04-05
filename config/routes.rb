Zhengquan::Application.routes.draw do
  resources :stores,:path=>'yyb' do
    collection do 
      get 'dirty'
    end
  end
  provinces = Regexp.new(Province.pluck(:name_en).join('|')) rescue nil
  match '/:province/:id' => 'stores#province_company',:as=>'province_company',:constraints=>{:province => provinces}
  match '/:province' => 'stores#province',:as=>'province',:constraints=>{:province => provinces}

  resources :companies 

  authenticated :user do
    root :to => 'home#index'
  end
  match '/companies/:id'=>'companies#city',:as=>'company_city'
  root :to => "companies#home"
  devise_for :users
  resources :users
  #get '/:id'=>'companies#show'
  get '/:id/yyb'=>'companies#yyb',:as=>'company_stores'
  get '/:id'=>'companies#show',:as=>'company_home'
end
