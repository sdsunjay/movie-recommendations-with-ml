window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete_city']");
  var options = {
    getValue: "name",
    url: function(phrase) {
      return "/autocomplete/city.json?name=" + phrase;
    },
    categories: [
      {
        listLocation: "cities"
      }
    ]
  };
  $input.easyAutocomplete(options);
});

