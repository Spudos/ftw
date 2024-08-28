function buildInputFields(inputDiv) {
  const items = {};

  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
      
    if (key && key.startsWith('ftw-')) {
      items[key] = sessionStorage.getItem(key);
    };
  };

  let i = 1;
  let index = 0;

  Object.entries(items).forEach(([key, value]) => {
    if (key === 'ftw-defence-aggression') {
      inputBuilder(inputDiv, 'dfc_aggression', value);
    } else if (key === 'ftw-midfield-aggression') {
      inputBuilder(inputDiv, 'mid_aggression', value);
    } else if (key === 'ftw-attack-aggression') {
      inputBuilder(inputDiv, 'att_aggression', value);
    } else if (key === 'ftw-coach') {
      inputBuilder(inputDiv, 'coach_upgrade', value);
    } else if (key === 'ftw-condition') {
      inputBuilder(inputDiv, 'stadium_condition_upgrade', value);
    } else if (key === 'ftw-press') {
      inputBuilder(inputDiv, 'press', value);
    } else if (key === 'ftw-property') {
      inputBuilder(inputDiv, 'property_upgrade', value);
    } else if (key === 'ftw-tactic') {
      inputBuilder(inputDiv, 'tactic', value);
    } else if (key === 'ftw-stadium') {
      inputBuilder(inputDiv, 'stadium_upgrade', value);
    } else if (key === 'ftw-stadium-amount') {
      inputBuilder(inputDiv, 'stadium_amount', value);
    } else if (key.startsWith('ftw-coach-gkp-')) {
      const playerId = key.replace('ftw-coach-gkp-', '');
      inputBuilder(inputDiv, 'train_goalkeeper', playerId);
      inputBuilder(inputDiv, 'train_goalkeeper_skill', value);
    } else if (key.startsWith('ftw-coach-dfc-')) {
      const playerId = key.replace('ftw-coach-dfc-', '');
      inputBuilder(inputDiv, 'train_defender', playerId);
      inputBuilder(inputDiv, 'train_defender_skill', value);
    } else if (key.startsWith('ftw-coach-mid-')) {
      const playerId = key.replace('ftw-coach-mid-', '');
      inputBuilder(inputDiv, 'train_midfielder', playerId);
      inputBuilder(inputDiv, 'train_midfielder_skill', value);
    } else if (key.startsWith('ftw-coach-att-')) {
      const playerId = key.replace('ftw-coach-att-', '');
      inputBuilder(inputDiv, 'train_attacker', playerId);
      inputBuilder(inputDiv, 'train_attacker_skill', value);
    } else if (value === 'fitness') {
      const playerId = key.replace('ftw-player-action-', '');
      inputBuilder(inputDiv, 'fitness_coaching', playerId);
    } else if (key.startsWith('ftw-selection-')) {
      const playerId = key.replace('ftw-selection-', '');
      inputBuilder(inputDiv, `player_${i}`, playerId);
      i++;
    } else if (key.startsWith('ftw-player-action-')) {
      const playerId = key.replace('ftw-player-action-', '');
      let amount = 0;

      if (value === 'loyalty' || value === 'contract') {
        amount = playerActionAmountGetter(playerId);
      };
      
      playerActionInputBuilder(inputDiv, value, playerId, amount, index);
      index++
    };
  });

  submitForm();
}

function inputBuilder(inputDiv, key, value) {
  const inputField = document.createElement('input');
  
  inputField.name = `turnsheet[${key}]`;
  inputField.type = 'hidden';
  inputField.value = value;

  inputDiv.appendChild(inputField);
}

function playerActionAmountGetter(playerId) {
  const key = `ftw-player-amount-${playerId}`;
  const amount = sessionStorage.getItem(key);

  return amount;
}

function playerActionInputBuilder(inputDiv, value, player_id, amount, index) {
  const inputField = document.createElement('input');
  const inputField1 = document.createElement('input');
  const inputField2 = document.createElement('input');

  inputField.name = `turnsheet[player_actions_attributes][${index}][action]`;
  inputField.type = 'hidden';
  inputField.value = value;

  inputField1.name = `turnsheet[player_actions_attributes][${index}][player_id]`;
  inputField1.type = 'hidden';
  inputField1.value = player_id;

  inputField2.name = `turnsheet[player_actions_attributes][${index}][amount]`;
  inputField2.type = 'hidden';
  inputField2.value = amount;

  inputDiv.appendChild(inputField);
  inputDiv.appendChild(inputField1);
  inputDiv.appendChild(inputField2);
}

function submitForm() {
  const form = document.getElementById('turnsheetForm');

  const hiddenInputsDiv = document.getElementById('hidden_inputs');
  const hiddenInputs = hiddenInputsDiv.querySelectorAll('input[type="hidden"]');

  hiddenInputs.forEach(input => {
    const clonedInput = input.cloneNode(true);
    form.appendChild(clonedInput);
  });

  form.submit();
  sessionStorage.clear();
}

export { buildInputFields };