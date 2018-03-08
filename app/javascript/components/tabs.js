
function switcher() {
  const switcher = document.getElementById("switcher");
  switcher.addEventListener("click", (event) => {

    const box = document.querySelectorAll(".alert-step");
    const line = document.querySelector(".line-left-inactive");
    const text2 = document.querySelector(".text-2");
    const bubble2 = document.querySelector(".rail-bubble-disabled-2");


    event.preventDefault();

    box[1].classList.toggle("active");
    box[0].classList.toggle("active");

    line.classList.replace("line-left-inactive", "line-left-active");
    text2.classList.replace("inactive", "active");
    bubble2.classList.replace("rail-bubble-disabled-2","rail-bubble-active-2");

  });
}


export { switcher };
