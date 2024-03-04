console.log("turnsheet.js loaded successfully");

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
});
