console.log("welcome.js loaded successfully");

document.addEventListener("DOMContentLoaded", function() {
  player.style.display = "block";
  matches.style.display = "none";
  club.style.display = "none";
});

const playerButton = document.getElementById('playerButton');
const matchButton = document.getElementById('matchButton');
const clubButton = document.getElementById('clubButton');

playerButton.addEventListener('click', function() {
  player.style.display = "block";
  matches.style.display = "none";
  club.style.display = "none";
});

matchButton.addEventListener('click', function() {
  player.style.display = "none";
  matches.style.display = "block";
  club.style.display = "none";
});

clubButton.addEventListener('click', function() {
  player.style.display = "none";
  matches.style.display = "none";
  club.style.display = "block";
});
