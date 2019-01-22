// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()
let buffer_id = location.pathname.split('/')[2];
let channel = socket.channel("buffer:" + buffer_id, {})
let bufferInput = document.querySelector("#currentBuffer")
let playButton = document.querySelector("#play")
let stopButton = document.querySelector("#stop")
let log = document.querySelector("#log")

bufferInput.addEventListener("keypress", event => {
  if(event.which === 174){
    event.preventDefault();
    channel.push("buffer", {id: buffer_id, buffer: bufferInput.value});
  }
})

playButton.addEventListener('click', event => {
  event.preventDefault();
  channel.push("buffer", {id: buffer_id, buffer: bufferInput.value});
})

stopButton.addEventListener('click', event => {
  event.preventDefault();
  channel.push("stop_buffer", {});
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on('buffer', payload => {
  console.log(payload)
});

channel.on('log', payload => {
  log.prepend(payload.log)
});

export default socket
