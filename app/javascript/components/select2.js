import $ from 'jquery';
import 'select2';


$('.select2-continent').select2({
  placeholder: "Select a continent",
  tags: true

});

$(".select2-country").select2({
    placeholder: "Select a country",
    tags: true
});

$(".select2-city").select2({
    placeholder: "Select a city",
    tags: true
});

import 'select2/dist/css/select2.css';
