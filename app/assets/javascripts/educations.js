document.addEventListener("turbolinks:load", function() {
  //$input = $("[data-behavior='autocomplete_education']")
  $input = $("#user_education_name");
  //$input = document.querySelection("[data-behavior='autocomplete']")
  var options = {
    getValue: "name",
    url: function(phrase) {
      return "/autocomplete/education.json?name=" + phrase;
    },
    categories: [
      {
        listLocation: "users",
        header: "<strong>Schools</strong>"
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
