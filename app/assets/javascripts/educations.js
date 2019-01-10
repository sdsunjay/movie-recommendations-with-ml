window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete_city']");
  var options = {
    getValue: "name",

    url: function(phrase) {
      return "/autocomplete/city.json?name=" + phrase;
    },

    listLocation: "cities",

    requestDelay: 300,

    //theme: "round",

    list: {
      maxNumberOfElements: 10
    },
  };
  $input.easyAutocomplete(options);
});

