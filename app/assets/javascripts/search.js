window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete']");
  var options = {
    getValue: "name",
    requestDelay: 350,
    url: function(phrase) {
      return "/autocomplete/search.json?title=" + phrase;
    },
    listLocation: "movies",
    list: {
      maxNumberOfElements: 10,
      match: {
        enabled: true
      },
      onChooseEvent: function () {
        var url = $input.getSelectedItemData().url
        $input.val("")
        Turbolinks.visit(url)
      }
    }
  };
  $input.easyAutocomplete(options);
});
