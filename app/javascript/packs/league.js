console.log("league.js loaded!");
  
// Add event listeners to the league, table, and fixtures buttons
var tableButton = document.getElementById("tableButton");
var playersButton = document.getElementById("playersButton");
var gkpButton = document.getElementById("gkpButton");
var dfcButton = document.getElementById("dfcButton");
var midButton = document.getElementById("midButton");
var attButton = document.getElementById("attButton");

tableButton.addEventListener("click", showTable);
playersButton.addEventListener("click", showPlayers);
gkpButton.addEventListener("click", showGkp);
dfcButton.addEventListener("click", showDfc);
midButton.addEventListener("click", showMid);
attButton.addEventListener("click", showAtt);

function showTable() {
  document.getElementById("table").style.display = "block";
  document.getElementById("players").style.display = "none";
  document.getElementById("gkp").style.display = "none";
  document.getElementById("dfc").style.display = "none";
  document.getElementById("mid").style.display = "none";
  document.getElementById("att").style.display = "none";
}

function showPlayers() {
  document.getElementById("table").style.display = "none";
  document.getElementById("players").style.display = "block";
  document.getElementById("gkp").style.display = "none";
  document.getElementById("dfc").style.display = "none";
  document.getElementById("mid").style.display = "none";
  document.getElementById("att").style.display = "none";
}

function showGkp() {
  document.getElementById("table").style.display = "none";
  document.getElementById("players").style.display = "none";
  document.getElementById("gkp").style.display = "block";
  document.getElementById("dfc").style.display = "none";
  document.getElementById("mid").style.display = "none";
  document.getElementById("att").style.display = "none";
}

function showDfc() {
  document.getElementById("table").style.display = "none";
  document.getElementById("players").style.display = "none";
  document.getElementById("gkp").style.display = "none";
  document.getElementById("dfc").style.display = "block";
  document.getElementById("mid").style.display = "none";
  document.getElementById("att").style.display = "none";
}

function showMid() {
  document.getElementById("table").style.display = "none";
  document.getElementById("players").style.display = "none";
  document.getElementById("gkp").style.display = "none";
  document.getElementById("dfc").style.display = "none";
  document.getElementById("mid").style.display = "block";
  document.getElementById("att").style.display = "none";
}

function showAtt() {
  document.getElementById("table").style.display = "none";
  document.getElementById("players").style.display = "none";
  document.getElementById("gkp").style.display = "none";
  document.getElementById("dfc").style.display = "none";
  document.getElementById("mid").style.display = "none";
  document.getElementById("att").style.display = "block";
}
