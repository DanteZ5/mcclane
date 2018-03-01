
function switcher() {
  const switcher = document.getElementById("switcher");
  switcher.addEventListener("click", (event) => {

    const box = document.querySelectorAll(".alert-step");
    const nav = document.querySelectorAll(".navh");

    event.preventDefault();

    box[1].classList.toggle("active");
    box[0].classList.toggle("active");
    nav[0].classList.toggle("active");
    nav[1].classList.toggle("active");
  });
}


export { switcher };
