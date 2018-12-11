window.addEventListener("turbolinks:load", Pagy.init);
window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete_education']");
  var options = {
    getValue: "name",
    url: function(phrase) {
      return "/autocomplete/education.json?name=" + phrase;
    },
    categories: [
      {
        listLocation: "educations",
        header: "<strong>Universities</strong>"
      }
    ]
  };
  $input.easyAutocomplete(options);
});
