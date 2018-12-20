document.addEventListener("DOMContentLoaded", function() {
  sendHeight()
})

window.addEventListener("resize", function() {
	sendHeight()
})

function sendHeight() {
  let docHeight = Math.max(
    document.body.scrollHeight, document.documentElement.scrollHeight,
    document.body.offsetHeight, document.documentElement.offsetHeight,
    document.body.clientHeight, document.documentElement.clientHeight
  )
  let message = {height: docHeight}
  parent.postMessage(message,"*")
}