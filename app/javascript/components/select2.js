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


$(".select2-continent, .select2-country, .select2-city").on("change", function() {

  // console.log("change");
  const continents = $(".select2-continent").val();
  const countries = $(".select2-country").val();
  const cities = $(".select2-city").val();

  // TODO: appel la url /collaborators/count?continents[]=Europe&continents[]=Afrique&countries[]=xxxx&cities[]=xxxx

  let url = "/collaborators/count?"
  let filters = [];

  continents.forEach((continent) => {
    filters.push(`continents[]=${continent}`);
  });

  countries.forEach((country) => {
    filters.push(`countries[]=${country}`);
  });

  cities.forEach((city) => {
    filters.push(`cities[]=${city}`);
  });

  url += filters.join("&");

  console.log(url);

  fetch(url, { credentials: 'same-origin' })
  .then(response => response.json())
  .then((data) => {
    const collaboratorsCount = data.count;
    document.getElementById("collaborators-count").innerText = collaboratorsCount;
  });
});

import 'select2/dist/css/select2.css';
