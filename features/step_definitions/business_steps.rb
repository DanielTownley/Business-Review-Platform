Given(/^I am logged in as "([^"]*)"'s owner$/) do |arg1|
  
end

When(/^"([^"]*)" adds a (\d+) star review on "([^"]*)"$/) do |arg1, arg2, arg3|
    u = User.find_or_create_by(name: arg1)
    b = Business.find_or_create_by(name: arg3)
    r = Review.create!(stars: arg2)
    u.reviews << r
    b.reviews << r
end

Given(/^I own a cafe called "([^"]*)" at (\d+) ([^"]*), ([^"]*), ([^"]*), (\d+)$/) do |name, st_num, st_name, city, state, zip|
    
    loc=Geokit::Geocoders::MultiGeocoder.geocode("#{st_num} #{st_name}, #{city}, #{state}")
    if loc.success
      #puts loc.lat
      #puts loc.lng
      #puts loc.full_address
      Business.create!(name: name, lat: loc.lat, lng: loc.lng)
    end
end

Given(/^other businesses around "([^"]*)" exist and have an average rating of (\d+) stars$/) do |arg1, arg2|
  # Write code here that turns the phrase above into concrete actions
  origin_lat = Business.find_by_name(arg1).lat
  origin_lng = Business.find_by_name(arg1).lng
  
end

Given(/^"([^"]*)" has an average rating of (\d+) stars$/) do |arg1, arg2|
  # Write code here that turns the phrase above into concrete actions
  b = Business.find_or_create_by(name: arg1)
  r = Review.create!(stars: arg2)
  b.reviews << r
end

Given(/^"([^"]*)" is a "([^"]*)"$/) do |arg1, arg2|
  # Write code here that turns the phrase above into concrete actions
  b = Business.find_or_create_by(name: arg1)
  t = Type.find_or_create_by(name: arg2)
  #p b.inspect
  #p t.inspect
  b.types << t
  t.businesses << b
end

#rails generate migration CreateJoinTableTypeBusiness type business