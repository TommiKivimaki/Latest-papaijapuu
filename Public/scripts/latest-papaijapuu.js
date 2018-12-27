document.addEventListener("DOMContentLoaded", function() {
                          sendLoaded()
                          sendHeight()
                          })

window.addEventListener("resize", function() {
                        sendHeight()
                        })

function sendLoaded() {
  let message = {status: "loaded"}
  parent.postMessage(message,"*")
}

function sendHeight() {
  let indexMessageList = document.getElementById("indexMessageList")
  
  if (indexMessageList !== null && indexMessageList !== undefined) {
//    let bodyHeight = document.body.scrollHeight
    let bodyHeight = $(document).height()
    let message = {height: bodyHeight}
    parent.postMessage(message,"*")
  }
}
