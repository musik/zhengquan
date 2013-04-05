namespace :dev do
  desc "import companies"
  task :import_companies => :environment do
    Company.delete_all
    Company.import_from_sac
    Company.import_all_stores
    Store::Fixer.detect_districts
  end
  desc "fix locations"
  task :fix_locations => :environment do
    #Store::Fixer.fix_provinces
    #Store::Fixer.fix_cities
    Store::Fixer.detect_districts
  end
end
