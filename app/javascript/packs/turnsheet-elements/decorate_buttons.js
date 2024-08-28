//-------------------------------------------------------------- Decorate Buttons
function resetButtonClasses(playerRows, skillCells) {
  const allButtons = document.querySelectorAll('button');

  allButtons.forEach(button => {
    if (button.classList.contains('btn-success')) {
      button.classList.remove('btn-success');
    };
  });

  allButtons.forEach(button => {
    if (!button.classList.contains('btn-outline-primary')) {
      button.classList.add('btn-outline-primary');
    };
  });

  playerRows.forEach(row => {
    row.classList.remove('table-success');
  });

  skillCells.forEach(cell => {
    cell.classList.remove('coached');
  });
};

function resetPlayerActions() {
  playerActionButtons.forEach(buttonGroup => {
    buttonGroup.querySelectorAll('button').forEach(button => {
      button.classList.remove('btn-success');
      button.classList.add('btn-outline-primary');
    });
  });

  playerActionAmounts.forEach(amountGroup => {
    amountGroup.querySelectorAll('button').forEach(button => {
      button.classList.remove('btn-success');
      button.classList.add('btn-outline-primary');
    });
  });
};

function readSessionStorage() {
  const items = {};

  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
      
    if (key && key.startsWith('ftw-')) {
      items[key] = sessionStorage.getItem(key);
    };
  };

  Object.entries(items).forEach(([key, value]) => {
    directSessionStorage(key, value);
  });
};  

function directSessionStorage(key, value) {
  if (key === 'ftw-attack-aggression') {
    decorateButtons(attackAggressionButtons, value);
  } else if (key === 'ftw-midfield-aggression') {
    decorateButtons(midfieldAggressionButtons, value);
  } else if (key === 'ftw-defence-aggression') {
    decorateButtons(defenceAggressionButtons, value);
  } else if (key === 'ftw-press') {
    decorateButtons(pressingButtons, value);
  } else if (key === 'ftw-tactic') {
    decorateButtons(tacticButtons, value);
  } else if (key === 'ftw-coach') {
    decorateButtons(coachButtons, value);
  } else if (key.startsWith('ftw-coach-')) {
    decorateTraining(key, value);
  } else if (key.startsWith('ftw-property')) {
    decorateButtons(propertyButtons, value);
  } else if (key.startsWith('ftw-selection')) {
    decorateSelection(key);
  } else if (key === ('ftw-stand')) {
    decorateButtons(stadiumButtons, value);
  } else if (key === ('ftw-condition')) {
    decorateButtons(conditionButtons, value);
  } else if (key === ('ftw-stadium-amount')) {
    decorateButtons(capacityButtons, value);
  }
};

function decorateButtons(buttons, value) {
  buttons.forEach(button => {
    if (button.id === value) {
      button.classList.add('btn-success');
      button.classList.remove('btn-outline-primary');
    };
  });
};

function decorateSelection(key) {
  const playerId = key.replace('ftw-selection-', '');
  
  playerRows.forEach(row => {
    if (row.dataset.playerId === playerId) {
        row.classList.add('table-success');
    };
  });
};

function decorateTraining(key, value) {
  const playerIDFromStorage = key.split('-').pop();

  skillCells.forEach(cell => {
    const row = cell.parentNode;
    const playerId = row.querySelector('#player_id').innerHTML;

    if (playerId === playerIDFromStorage) {
      if (cell.id === value) {
        cell.classList.add('coached');
      };
    };
  });
};

function decoratePlayerActions(playerActionButtons) {
  playerActionButtons.forEach(buttonGroup => {
    buttonGroup.querySelectorAll('button').forEach(button => {
      const playerId = button.dataset.playerId;
      const currentAction = sessionStorage.getItem('ftw-player-action-' + playerId);
      const currentAmount = sessionStorage.getItem('ftw-player-action-amount-' + playerId);

      if (currentAction === button.id) {
        button.classList.add('btn-success');
        button.classList.remove('btn-outline-primary');
      };

      if (currentAmount === button.id) {
        button.classList.add('btn-success');
        button.classList.remove('btn-outline-primary');
      };
    });
  });
};

function decoratePlayerAmounts(playerActionAmounts) {
  playerActionAmounts.forEach(amountGroup => {
    amountGroup.querySelectorAll('button').forEach(button => {
      const playerId = button.dataset.playerId;
      const currentAmount = sessionStorage.getItem('ftw-player-action-amount-' + playerId);

      if (currentAmount === button.id) {
        button.classList.add('btn-success');
        button.classList.remove('btn-outline-primary');
      };
    });
  });
};

export { resetButtonClasses, resetPlayerActions, readSessionStorage, decoratePlayerActions, decoratePlayerAmounts };