window.addEventListener("turbolinks:load", Pagy.init);
window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete_education']");
  var options = {
    getValue: "name",
    requestDelay: 350,
    url: function(phrase) {
      return "/autocomplete/education.json?name=" + phrase;
    },
    listLocation: "educations",
    list: {
      maxNumberOfElements: 10
    }
  };
  $input.easyAutocomplete(options);
});
window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete_location']");
  var options = {
    getValue: "name",
    requestDelay: 350,
    url: function(phrase) {
      return "/autocomplete/city.json?name=" + phrase;
    },
    listLocation: "cities",
    list: {
      maxNumberOfElements: 10,
      match: {
        enabled: true
      }
    }
  };
  $input.easyAutocomplete(options);
});
