json.cities do
  json.array!(@cities) do |city|
    json.name city.city_and_state
  end
end
