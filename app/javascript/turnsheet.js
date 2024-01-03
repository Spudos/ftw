/*jshint esversion: 6 */
// **** Turnsheet From ****
// Add focus to the name field on page load
window.onload = function() {
  document.getElementById("name").focus();
};

// Make the submit button trigger the form submission when "Enter" is pressed
document.addEventListener("keydown", function(event) {
  if (event.key === "Enter") {
    document.getElementById("submitButton").click();
  }
});

// perform form validation
function validateForm() {

  // check a name is submitted
  const nameInput = document.getElementById("name");
  const name = nameInput.value;
  
  if (name.trim() === "") {
    alert("Please fill in your name");
    return false;
  }

  // check a valid email is submitted
  const emailInput = document.getElementById("email");
  const email = emailInput.value;
  const emailFormat = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  
  if (!email.match(emailFormat)) {
    alert("Please enter a valid email address");
    return false;
  }

  // check comments have been filled in
  const commentsInput = document.getElementById("comments");
  const comments = commentsInput.value;
  
  if (comments.trim() === "") {
    alert("Please fill in your comments");
    return false;
  }

  // check a feedback type has been selected
  const radioButtons = document.getElementsByName("feedbackType");
  let radioSelected = false;
  for (let i = 0; i < radioButtons.length; i++) {
    if (radioButtons[i].checked) {
      radioSelected = true;
      break;
    }
  }
  if (!radioSelected) {
    alert("Please select a feedback type");
    return false;
  }

// Hide the form and show the summary
document.getElementById("feedbackForm").style.display = "none";
document.getElementById("content").style.display = "block";

// Display the submitted information in the summary using a template literal
const summaryTemplate = `
  <h3>Thank you for your feedback</h3>
  <p>Name: ${name}</p>
  <p>Email: ${email}</p>
  <p>Feedback Type: ${document.querySelector('input[name="feedbackType"]:checked').value}</p>
  <p>Comments: ${comments}</p>
`;

document.getElementById("content").innerHTML = summaryTemplate;

// Prevent the form from actually submitting
return false;
}