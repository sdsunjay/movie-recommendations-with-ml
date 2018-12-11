window.addEventListener("turbolinks:load", function() {
  var $input = $("[data-behavior='autocomplete']");
  var options = {
    getValue: "name",
    url: function(phrase) {
      return "/autocomplete/search.json?title=" + phrase;
    },
    categories: [
      {
        listLocation: "movies",
        header: "<strong>Movies</strong>"
      }
    ],
    list: {
      onChooseEvent: function () {
        var url = $input.getSelectedItemData().url
        $input.val("")
        Turbolinks.visit(url)
      }
    }
  };
  $input.easyAutocomplete(options);
});
