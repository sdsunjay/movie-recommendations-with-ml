window.addEventListener("turbolinks:load", Pagy.init);
jQuery(function() {
  return $('#user_education').autocomplete({
    source: ['Cal Poly', 'UC Berkeley', 'UC Davis']
    //source: $('#product_category_name').data('autocomplete-source')
  });
});
