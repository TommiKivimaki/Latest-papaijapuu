document.addEventListener("DOMContentLoaded", function() {
                          sendHeight()
                          })

window.addEventListener("resize", function() {
                        sendHeight()
                        })

function sendHeight() {
  let indexMessageList = document.getElementById("indexMessageList")
  
  if (indexMessageList !== null && indexMessageList !== undefined) {
//    let bodyHeight = document.body.scrollHeight
    let bodyHeight = $(document).height()
    let message = {height: bodyHeight}
    parent.postMessage(message,"*")
  }
}
