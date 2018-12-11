json.educations do
  json.array!(@educations) do |education|
    json.name education.name
    json.url education_path(education)
  end
end
