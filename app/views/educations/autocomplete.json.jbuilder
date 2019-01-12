json.educations do
  json.array!(@educations) do |education|
    json.name education.name
  end
end
