function buildInputFields(inputDiv) {
  const items = {};

  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
      
    if (key && key.startsWith('ftw-')) {
      items[key] = sessionStorage.getItem(key);
    };
  };

  let i = 1;

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
    } 
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

function submitForm() {
  const form = document.getElementById('turnsheetForm');

  const hiddenInputsDiv = document.getElementById('hidden_inputs');
  const hiddenInputs = hiddenInputsDiv.querySelectorAll('input[type="hidden"]');

  hiddenInputs.forEach(input => {
    const clonedInput = input.cloneNode(true);
    form.appendChild(clonedInput);
  });

  form.submit();
}

export { buildInputFields };