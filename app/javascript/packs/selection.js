console.log("selection.js loaded successfully");

document.addEventListener("DOMContentLoaded", function() {
  var availableItems = document.getElementById("availableItems");
  var selectedItems = document.getElementById("selectedItems");

  // Function to handle item click in the first list
  function addItem(event) {
    var item = event.target;
    item.classList.add("selected");
    item.removeEventListener("click", addItem);
    item.addEventListener("click", removeItem);
    selectedItems.appendChild(item);
  }

  // Function to handle item click in the second list
  function removeItem(event) {
    var item = event.target;
    item.classList.remove("selected");
    item.removeEventListener("click", removeItem);
    item.addEventListener("click", addItem);
    availableItems.appendChild(item);
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

