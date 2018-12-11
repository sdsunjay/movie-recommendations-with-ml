document.addEventListener("turbolinks:load", function() {
  $input = $("[data-behavior='autocomplete']")
  //$input = document.querySelection("[data-behavior='autocomplete']")
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
        console.log(url)
        $input.val("")
        Turbolinks.visit(url)
      }
    }
  };
  $input.easyAutocomplete(options)
});
