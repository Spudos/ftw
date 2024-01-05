document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('turnsheet');
  const weekField = document.getElementById('turnsheet_week');

  form.addEventListener('submit', function(event) {
    if (weekField.value === '') {
      event.preventDefault();
      alert('Please select a week before submitting the form.');
    }
  });
});

document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('#turnsheet'); // Use # to select by ID

  form.addEventListener('submit', function(event) {
    const playerFields = form.querySelectorAll('select[id^="turnsheet_player_"]');

    for (let i = 0; i < playerFields.length; i++) {
      if (playerFields[i].value === '') {
        event.preventDefault();
        alert('Please select a player for all positions.');
        return;
      }
    }
  });
});
