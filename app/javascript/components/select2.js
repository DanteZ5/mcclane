import $ from 'jquery';
import 'select2';


// $('.select2-continent').select2({
//   placeholder: "Select a continent",
//   tags: true

// });

// $(".select2-country").select2({
//     placeholder: "Select a country",
//     tags: true
// });

// $(".select2-city").select2({
//     placeholder: "Select a city",
//     tags: true
// });

$(".select2-area").select2({
  placeholder: "Select areas (continents, countries, cities)",
  tags: true
});


$(".select2-area").on("change", function() {

  console.log("change");
  // const continents = $(".select2-continent").val();
  // const countries = $(".select2-country").val();
  // const cities = $(".select2-city").val();
  const areas = $(".select2-area").val();

  // TODO: appel la url /collaborators/count?continents[]=Europe&continents[]=Afrique&countries[]=xxxx&cities[]=xxxx

  let url = "/collaborators/count?"
  let filters = [];

  // continents.forEach((continent) => {
  //   filters.push(`continents[]=${continent}`);
  // });

  // countries.forEach((country) => {
  //   filters.push(`countries[]=${country}`);
  // });

  // cities.forEach((city) => {
  //   filters.push(`cities[]=${city}`);
  // });

  areas.forEach((area) => {
    filters.push(`areas[]=${area}`);
  });

  url += filters.join("&");

  console.log(url);

  fetch(url, { credentials: 'same-origin' })
  .then(response => response.json())
  .then((data) => {
    const collaboratorsCount = data.count;
    document.getElementById("collaborators-count").innerText = collaboratorsCount;
    const menDiv = document.getElementById("men").innerHTML = "<i class='fas fa-user man'></i>".repeat(collaboratorsCount)
  });
});

import 'select2/dist/css/select2.css';
