document.addEventListener("DOMContentLoaded", function() {
  sendHeight()
})

window.addEventListener("resize", function() {
	sendHeight()
})

function sendHeight() {
  let docHeight = document.getElementById("main-element").scrollHeight
  let message = {height: docHeight}
  parent.postMessage(message,"*")
}