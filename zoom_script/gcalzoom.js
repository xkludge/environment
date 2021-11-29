// ==UserScript==
// @name        Launch Zoom from Google Calendar Meeting Rooms
// @namespace   Violentmonkey Scripts
// @match       https://calendar.google.com/calendar/*
// @grant       none
// @version     1.0
// @author      Matthew Eagar <meagar@hey.com>
// @description When you click on a meeting room like "TO HotPot 222-333-4444 (5)", instead of opening Google Maps, launch zoom
// ==/UserScript==

console.log("Zoom Clicker: Starting up");

function on(el, eventName, elementSelector, handler) {
  el.addEventListener(eventName, function(e) {
      // loop parent nodes from the target to the delegation node
      for (var target = e.target; target && target != this; target = target.parentNode) {
          if (target.matches(elementSelector)) {
              handler.call(target, e);
              break;
          }
      }
  }, false);
}

on(document, "click", "a", (e) => {
  console.log("Handling a click", e);
  
  // Try to find the <a> tag
  let element = e.target;
  while (element &&  element.tagName != "A") {
    element = element.parentElement;
  }
  
  if (!element || element.tagName != "A") {
    console.log("couldn't find an <a> tag")
    return;
  }
  
  const url = new URL(element.href);
  
  if (url.host != "maps.google.com") {
    console.log("link's host didn't match maps.google.com")
    return;
  }
  
  const params = url.search.split("&").reduce((hash, e) => {
    const pair = e.split("=").map(e => decodeURIComponent(e));
    hash[pair[0]] = pair[1];
    return hash;
  }, {});
  
  if (!params.q) {
    console.log("Found no q in query string")
    return;
  }
  
  const meetingId = params.q.match(/\b\d\d\d-\d\d\d-\d\d\d\d?\b/)[0]
  
  if (!meetingId) {
    console.log("Found no meeting id")
    return;
  }
  
  console.log("Found meeting ID", meetingId);
  
  console.log(window.open("https://prodigygame.zoom.us/j/" + meetingId))

  event.preventDefault(); 
});