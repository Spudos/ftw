import { setTacticValue, setPressValue, setDefenceAggression, setMidfieldAggression, setAttackAggression } from './turnsheet-elements/tactics.js';
import { resetUpgradeValues, setStaffValues, setPropertyValues, setCapacityValues, setConditionValues } from './turnsheet-elements/club.js';
import { addScoutingListener } from './turnsheet-elements/scouting.js';
import { handlePlayerClick, teamValidations, formationUpdate } from './turnsheet-elements/team.js';
import { handleSkillClick } from './turnsheet-elements/training.js';
import { buildInputFields } from './turnsheet-elements/submit.js';
import { addTransferListener } from './turnsheet-elements/transfers.js';
import { setBlendValues } from './turnsheet-elements/blend.js';

const stadiumButtons = document.querySelectorAll('#stand_navigation button');
const capacityButtons = document.querySelectorAll('#stand_capacity button');
const conditionButtons = document.querySelectorAll('#stand_condition button');
const coachButtons = document.querySelectorAll('#coach_selection button');
const propertyButtons = document.querySelectorAll('#property_selection button');
const skillCells = document.querySelectorAll('td.skill');

const blendButtons = document.querySelectorAll('#blend_selection button');

const playerRows = document.querySelectorAll('.player-row');
const submitButton = document.getElementById('submitButton');
const tacticButtons = document.querySelectorAll('#tactic_selection button');
const pressingButtons = document.querySelectorAll('#pressing_selection button');
const defenceAggressionButtons = document.querySelectorAll('#defence_aggression button');
const midfieldAggressionButtons = document.querySelectorAll('#midfield_aggression button');
const attackAggressionButtons = document.querySelectorAll('#attack_aggression button');
const inputDiv = document.getElementById('hidden_inputs');

const playerActionButtons = document.querySelectorAll('[id^="player-action-buttons-"]');
const playerActionAmounts = document.querySelectorAll('[id^="player-action-amounts-"]');

const headlineInput = document.getElementById('article_headline');
const subHeadlineInput = document.getElementById('article_sub_headline');
const articleInput = document.getElementById('article');
const messageInput = document.getElementById('club_message');
const messageText = document.getElementById('message_text');
const publicMessage = document.getElementById('public_message');

console.log('Turnsheet JS loaded');

teamValidations();
formationUpdate();
decoratePlayerActions();
decoratePlayerAmounts();
readSessionStorage();
addTransferListener();
addScoutingListener();

//------ Add Event Listeners
function addEventListeners(buttons) {
  buttons.forEach(button => {
    button.addEventListener('click', function(event) {
      event.preventDefault();
      handleButtonClick(button, buttons);
    });
  });
};


playerActionButtons.forEach(buttonGroup => {
  buttonGroup.querySelectorAll('button').forEach(button => {
    button.addEventListener('click', function(event) {
      const clickedButton = event.target;
      setPlayerAction(clickedButton);
    });
  });
});

playerActionAmounts.forEach(amountGroup => {
  amountGroup.querySelectorAll('button').forEach(button => {
    button.addEventListener('click', function(event) {
      const clickedButton = event.target;
      setPlayerAmount(clickedButton);
    });
  });
});


submitButton.addEventListener('click', function(event) {
  event.preventDefault();
  buildInputFields(inputDiv);
});

headlineInput.addEventListener('input', function() {
  sessionStorage.setItem('ftw-article_headline', headlineInput.value);
  subHeadlineInput.disabled = headlineInput.value.trim() === '';
});

subHeadlineInput.addEventListener('input', function() {
  sessionStorage.setItem('ftw-article_sub_headline', subHeadlineInput.value);
  articleInput.disabled = subHeadlineInput.value.trim() === '';
});

articleInput.addEventListener('input', function() {
  sessionStorage.setItem('ftw-article', articleInput.value);
});

messageInput.addEventListener('input', function() {
  sessionStorage.setItem('ftw-club_message', messageInput.value);
  messageText.disabled = messageInput.value.trim() === '';
});

messageText.addEventListener('input', function() {
  sessionStorage.setItem('ftw-message_text', messageText.value);
});

publicMessage.addEventListener('input', function() {
  sessionStorage.setItem('ftw-public_message', publicMessage.value);
});

//------ Run Button Listeners
addEventListeners(stadiumButtons);
addEventListeners(capacityButtons);
addEventListeners(conditionButtons);
addEventListeners(coachButtons);
addEventListeners(propertyButtons);
addEventListeners(blendButtons);
addEventListeners(skillCells);
addEventListeners(playerRows);
addEventListeners(tacticButtons);
addEventListeners(pressingButtons);
addEventListeners(defenceAggressionButtons);
addEventListeners(midfieldAggressionButtons);
addEventListeners(attackAggressionButtons);

//------ Handle Button Clicks
function handleButtonClick(button) {
  const capacityValues = ['2000', '4000', '6000', '8000'];
  const stadiumValues = ['n', 'e', 's', 'w'];
  const propertyValues = ['pitch', 'hospitality', 'facilities'];
  const blendValues = ['dfc', 'mid', 'att'];

  if (stadiumValues.includes(button.id)){
    resetUpgradeValues(button, stadiumButtons);
  } else if (button.id.startsWith("staff")) {
    setStaffValues(button);
  } else if (propertyValues.includes(button.id)) {
    setPropertyValues(button);
  } else if (blendValues.includes(button.id)) {
    setBlendValues(button, blendButtons);
  } else if (button.id.startsWith("condition")) {
    setConditionValues(button, stadiumButtons);
  } else if (capacityValues.includes(button.id)){
    setCapacityValues(button, stadiumButtons);
  } else if (button.classList.contains('skill')) {
    handleSkillClick(button);
  } else if (button.classList.contains('player-row')) {
    handlePlayerClick(button);
  } else if (button.classList.contains('tactic')) {
    setTacticValue(button);
  } else if (button.classList.contains('press')) {
    setPressValue(button);
  } else if (button.classList.contains('dfcAgg')) {
    setDefenceAggression(button);
  } else if (button.classList.contains('midAgg')) {
    setMidfieldAggression(button);
  } else if (button.classList.contains('attAgg')) {
    setAttackAggression(button); 
  };

  resetButtonClasses();
  readSessionStorage();
  decoratePlayerAmounts();
  decoratePlayerActions();
};

function setPlayerAction(clickedButton) {
  const playerId = clickedButton.dataset.playerId;
  const currentAction = sessionStorage.getItem('ftw-player-action-' + playerId);
  const newAmount = clickedButton.id;

  if (newAmount === 'fitness') {
    removeFitness();
  } else if (newAmount === 'blend') {
    removeBlend();
  };

  if (currentAction === newAmount) {
    sessionStorage.removeItem('ftw-player-action-' + playerId);
  } else {
    sessionStorage.setItem('ftw-player-action-' + playerId, newAmount);
  };

  resetPlayerActions()
  decoratePlayerAmounts();
  decoratePlayerActions();
};

function setPlayerAmount(clickedButton) {
  const playerId = clickedButton.dataset.playerId;
  const currentAmount = sessionStorage.getItem('ftw-player-amount-' + playerId);
  const newAmount = clickedButton.id;

  if (currentAmount === newAmount) {
    sessionStorage.removeItem('ftw-player-amount-' + playerId);
  } else {
    sessionStorage.setItem('ftw-player-amount-' + playerId, newAmount);
  };

  resetPlayerActions()
  decoratePlayerAmounts();
  decoratePlayerActions();
};

function removeFitness() {
  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
    const value = sessionStorage.getItem(key);

    if (value === "fitness") {
        sessionStorage.removeItem(key);
    };
  };
};

function removeBlend() {
  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
    const value = sessionStorage.getItem(key);

    if (value === "blend") {
        sessionStorage.removeItem(key);
    };
  };
};
//-------------------------------------------------------------- Decorate Buttons
//------ Read Session Storage
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

//------ Direct Session Storage to correct decorators
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
  } else if (key.startsWith('ftw-blend')) {
    decorateButtons(blendButtons, value);
  } else if (key.startsWith('ftw-selection')) {
    decorateSelection(key);
  } else if (key === ('ftw-stand')) {
    decorateButtons(stadiumButtons, value);
  } else if (key === ('ftw-condition')) {
    decorateCondition();
  } else if (key === ('ftw-stadium-amount')) {
    decorateButtons(capacityButtons, value);
  } else if (key.startsWith('ftw-transfer')) {
    decorateTransfers(key, value);
  } else if (key.startsWith('ftw-article') || key.startsWith('ftw-club_message') || key.startsWith('ftw-message_text') || key.startsWith('ftw-public_message')) {
    decorateMessages(key, value);
  } else if (key.startsWith('ftw-scouting-position') || key.startsWith('ftw-scouting-total_skill') || key.startsWith('ftw-scouting-age') || key.startsWith('ftw-scouting-skills') || key.startsWith('ftw-scouting-loyalty') || key.startsWith('ftw-scouting-potential_skill') || key.startsWith('ftw-scouting-consistency') || key.startsWith('ftw-scouting-recovery') || key.startsWith('ftw-scouting-star')) {
    decorateScouting(key, value);
  }

};

function resetButtonClasses() {
  //------ Reset all buttons to default
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

//------ Decorate Buttons
function decorateButtons(buttons, value) {
  buttons.forEach(button => {
    if (button.id === value) {
      button.classList.add('btn-success');
      button.classList.remove('btn-outline-primary');
    };
  });
};

function decorateCondition() {
  conditionButtons.forEach(button => {
    button.classList.add('btn-success');
    button.classList.remove('btn-outline-primary');
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

function decoratePlayerActions() {
  playerActionButtons.forEach(buttonGroup => {
    buttonGroup.querySelectorAll('button').forEach(button => {
      const playerId = button.dataset.playerId;
      const currentAction = sessionStorage.getItem('ftw-player-action-' + playerId);
      const currentAmount = sessionStorage.getItem('ftw-player-amount-' + playerId);

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

function decoratePlayerAmounts() {
  playerActionAmounts.forEach(amountGroup => {
    amountGroup.querySelectorAll('button').forEach(button => {
      const playerId = button.dataset.playerId;
      const currentAmount = sessionStorage.getItem('ftw-player-amount-' + playerId);

      if (currentAmount === button.id) {
        button.classList.add('btn-success');
        button.classList.remove('btn-outline-primary');
      };
    });
  });
};

function decorateScouting(key, value) {
  const inputId = key.replace('ftw-scouting-', '');

  if (inputId === 'position') {
    const radioButtons = document.querySelectorAll('input[name="position"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'total_skill') {
    const radioButtons = document.querySelectorAll('input[name="total_skill"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'age') {
    const radioButtons = document.querySelectorAll('input[name="age"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'skills') {
    const radioButtons = document.querySelectorAll('input[name="skills"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'loyalty') {
    const radioButtons = document.querySelectorAll('input[name="loyalty"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'potential_skill') {
    const radioButtons = document.querySelectorAll('input[name="potential_skill"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'consistency') {
    const radioButtons = document.querySelectorAll('input[name="consistency"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'recovery') {
    const radioButtons = document.querySelectorAll('input[name="recovery"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'star') {
    const radioButtons = document.querySelectorAll('input[name="star"]');
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  };
}

function decorateTransfers(key, value) {
  const inputId0 = key.replace('ftw-transfer_', '');
  const inputId = inputId0.slice(0, 4);
  const trimmedKey = key.replace('ftw-', '');

  if (inputId === 'type') {
    const radioButtons = document.querySelectorAll(`input[name=${trimmedKey}]`);
    radioButtons.forEach(radio => {
      if (radio.value === value) {
        radio.checked = true;
      }
    });
  }
  else if (inputId === 'play') {
    const transferPlayerId = document.getElementById(trimmedKey);
    transferPlayerId.value = value;
  }
  else if (inputId === 'amou') {
    const transferAmount = document.getElementById(trimmedKey);
    transferAmount.value = value;
  }
  else if (inputId === 'club') {
    const TransferOtherClub = document.getElementById(trimmedKey);
    TransferOtherClub.value = value;
  };
};

function decorateMessages (key, value) {
  const shortKey = key.replace('ftw-', '');

  if (shortKey === 'article_headline') {
    headlineInput.value = value;
  } else if (shortKey === 'article_sub_headline') {
    subHeadlineInput.disabled = headlineInput.value.trim() === '';
    subHeadlineInput.value = value;
  } else if (shortKey === 'article') {
    articleInput.disabled = subHeadlineInput.value.trim() === '';
    articleInput.value = value;
  } else if (shortKey === 'club_message') {
    messageInput.value = value;
  } else if (shortKey === 'message_text') {
    messageText.disabled = messageInput.value.trim() === '';
    messageText.value = value;
  } else if (shortKey === 'public_message') {
    publicMessage.value = value;
  };
};

