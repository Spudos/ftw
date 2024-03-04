console.log("league.js loaded!");
  
// Add event listeners to the league, table, and fixtures buttons
var tableButton = document.getElementById("tableButton");
var statisticsButton = document.getElementById("statisticsButton");
var fixturesButton = document.getElementById("fixturesButton");

tableButton.addEventListener("click", showTable);
statisticsButton.addEventListener("click", showStatistics);
fixturesButton.addEventListener("click", showFixtures);

// Function to show the league div
function showTable() {
  document.getElementById("table").style.display = "block";
  document.getElementById("statistics").style.display = "none";
  document.getElementById("fixtures").style.display = "none";
}

// Function to show the table div
function showStatistics() {
  document.getElementById("table").style.display = "none";
  document.getElementById("statistics").style.display = "block";
  document.getElementById("fixtures").style.display = "none";
}

// Function to show the fixtures div
function showFixtures() {
  document.getElementById("table").style.display = "none";
  document.getElementById("statistics").style.display = "none";
  document.getElementById("fixtures").style.display = "block";
}
