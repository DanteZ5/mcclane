
function messenger() {
  const message_container = document.getElementById('event_template_description') || document.getElementById('message_content');
  message_container.addEventListener("keyup", (event) => {
  const message = message_container.value;
  const template = document.querySelector('.message');
  template.innerHTML = ""
  template.insertAdjacentHTML('beforeend', message);
  });
}

export { messenger };

