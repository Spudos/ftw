document.addEventListener('DOMContentLoaded', function() {
  console.log("turnsheet.js loaded successfully");
  const form = document.getElementById('turnsheet');
  const weekField = document.getElementById('turnsheet_week');
  const trainGkpField = document.getElementById('turnsheet_train_gkp');
  const trainGkpSkillField = document.getElementById('turnsheet_train_gkp_skill');
  const trainDfcField = document.getElementById('turnsheet_train_dfc');
  const trainDfcSkillField = document.getElementById('turnsheet_train_dfc_skill');
  const trainMidField = document.getElementById('turnsheet_train_mid');
  const trainMidSkillField = document.getElementById('turnsheet_train_mid_skill');
  const trainAttField = document.getElementById('turnsheet_train_att');
  const trainAttSkillField = document.getElementById('turnsheet_train_att_skill');
  const stadUpgField = document.getElementById('turnsheet_stad_upgrade');
  const stadAmtField = document.getElementById('turnsheet_stad_amt');
  const playerFields = form.querySelectorAll('select[id^="turnsheet_player_"]');

  function validateForm(event) {

    if (weekField.value === '') {
      event.preventDefault();
      alert('Please select a week before submitting the form.');
    }

    if (trainGkpField.value !== '' && trainGkpSkillField.value === '') {
      event.preventDefault();
      alert(`You want to train goalkeeper ${trainGkpField.value} but you have not selected a skill`);
    }

    if (trainDfcField.value !== '' && trainDfcSkillField.value === '') {
      event.preventDefault();
      alert(`You want to train defender ${trainDfcField.value} but you have not selected a skill`);
    }

    if (trainMidField.value !== '' && trainMidSkillField.value === '') {
      event.preventDefault();
      alert(`You want to train midfielder ${trainMidField.value} but you have not selected a skill`);
    }

    if (trainAttField.value !== '' && trainAttSkillField.value === '') {
      event.preventDefault();
      alert(`You want to train attacker ${trainAttField.value} but you have not selected a skill`);
    }

    if (stadUpgField.value !== '' && stadAmtField.value === '') {
      event.preventDefault();
      alert(`You want to develop a stand but you have not selected the number of seats you wish to add`);
    }

    for (let i = 0; i < playerFields.length; i++) {
      console.log(playerFields[i].value)
      }    

    for (let i = 0; i < playerFields.length; i++) {
      if (playerFields[i].value === '') {
        event.preventDefault();
        alert('Please select a player for all positions');
        return;
      }
    }
  }

  form.addEventListener('submit', validateForm);

});


