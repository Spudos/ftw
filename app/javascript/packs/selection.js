console.log("selection.js loaded successfully");

document.addEventListener("DOMContentLoaded", function() {
  var availableItems = document.getElementById("availableItems");
  var selectedItems = document.getElementById("selectedItems");

  // Function to handle item click in the first list
  function addItem(event) {
    var item = event.target;
    if (item.textContent.includes("GKP")) {
      item.style.backgroundColor = "lightgreen"; // Change the background color
    } else if (item.textContent.includes("DFC")) {
      item.style.backgroundColor = "lightblue"; // Change the background color
    } else if (item.textContent.includes("MID")) {
      item.style.backgroundColor = "lightyellow"; // Change the background color
    } else if (item.textContent.includes("ATT")) {
      item.style.backgroundColor = "lightcoral"; // Change the background color
    }

    item.classList.add("selected");
    item.removeEventListener("click", addItem);
    item.addEventListener("click", removeItem);
    selectedItems.appendChild(item);
    countPlayers(); // Call the countPlayers function
  }

  // Function to handle item click in the second list
  function removeItem(event) {
    var item = event.target;
    item.classList.remove("selected");
    item.removeEventListener("click", removeItem);
    item.addEventListener("click", addItem);
    availableItems.appendChild(item);
    countPlayers(); // Call the countPlayers function
  }

  // Function to count the number of players in the selected div
  function countPlayers() {
    var gkpCount = 0;
    var dfcCount = 0;
    var midCount = 0;
    var attCount = 0;
    var items = selectedItems.getElementsByClassName("item");
  
    for (var i = 0; i < items.length; i++) {
      if (items[i].textContent.includes("GKP")) {
        gkpCount++;
      } else if (items[i].textContent.includes("DFC")) {
        dfcCount++;
      } else if (items[i].textContent.includes("MID")) {
        midCount++;
      } else if (items[i].textContent.includes("ATT")) {
        attCount++;
      }
    }
  
    document.getElementById("gkpCount").textContent = gkpCount;
    document.getElementById("dfcCount").textContent = dfcCount;
    document.getElementById("midCount").textContent = midCount;
    document.getElementById("attCount").textContent = attCount;
  }
  

  // Add event listeners to the items in the first list
  var availableItemElements = availableItems.getElementsByClassName("item");
  for (var i = 0; i < availableItemElements.length; i++) {
    availableItemElements[i].addEventListener("click", addItem);
  }

  // Add event listeners to the items in the second list
  var selectedItemElements = selectedItems.getElementsByClassName("item");
  for (var i = 0; i < selectedItemElements.length; i++) {
    selectedItemElements[i].addEventListener("click", removeItem);
  }

  // Function to handle form submission
  function handleSubmit(event) {
    event.preventDefault();

    // Get the count values
    var gkpCount = parseInt(document.getElementById("gkpCount").textContent);
    var dfcCount = parseInt(document.getElementById("dfcCount").textContent);
    var midCount = parseInt(document.getElementById("midCount").textContent);
    var attCount = parseInt(document.getElementById("attCount").textContent);

    // Calculate the total number of players
    var totalPlayers = gkpCount + dfcCount + midCount + attCount;

    // Check if all counts are at least 1 and the total number of players is 11
    if (gkpCount < 1 || dfcCount < 1 || midCount < 1 || attCount < 1 || totalPlayers !== 11) {
      var errorMessage = "Error: At least one position must have at least 1 player, and the total number of players must be 11.";
      var errorElement = document.createElement("div");
      errorElement.classList.add("error-message");
      errorElement.textContent = errorMessage;
      // Append the error message to a suitable location in the user interface
      var formContainer = document.getElementById("form-container");
      formContainer.insertBefore(errorElement, formContainer.firstChild);
    } else {
      // Proceed with the form submission
      event.target.submit();
    }
  }

  // Add event listener to the form for submission
  var form = document.querySelector('form');
  form.addEventListener("submit", handleSubmit);

});
