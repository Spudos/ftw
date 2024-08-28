import { setTacticValue, setPressValue, setDefenceAggression, setMidfieldAggression, setAttackAggression } from './turnsheet-elements/tactics.js';
import { resetUpgradeValues, setStaffValues, setPropertyValues, setCapacityValues, setConditionValues } from './turnsheet-elements/club.js';
import { handlePlayerClick, teamValidations, formationUpdate } from './turnsheet-elements/team.js';
import { handleSkillClick } from './turnsheet-elements/training.js';
import { buildInputFields } from './turnsheet-elements/submit.js';

document.addEventListener('DOMContentLoaded', function() {
  const stadiumButtons = document.querySelectorAll('#stand_navigation button');
  const capacityButtons = document.querySelectorAll('#stand_capacity button');
  const conditionButtons = document.querySelectorAll('#stand_condition button');
  const coachButtons = document.querySelectorAll('#coach_selection button');
  const propertyButtons = document.querySelectorAll('#property_selection button');
  const skillCells = document.querySelectorAll('td.skill');
  const playerActionButtons = document.querySelectorAll('[id^="player-action-buttons-"]');
  const playerActionAmounts = document.querySelectorAll('[id^="player-action-amounts-"]');
  const playerRows = document.querySelectorAll('.player-row');
  const submitButton = document.getElementById('submitButton');
  const tacticButtons = document.querySelectorAll('#tactic_selection button');
  const pressingButtons = document.querySelectorAll('#pressing_selection button');
  const defenceAggressionButtons = document.querySelectorAll('#defence_aggression button');
  const midfieldAggressionButtons = document.querySelectorAll('#midfield_aggression button');
  const attackAggressionButtons = document.querySelectorAll('#attack_aggression button');
  const inputDiv = document.getElementById('hidden_inputs');

  teamValidations();
  formationUpdate();
  decoratePlayerActions();
  decoratePlayerAmounts();
  readSessionStorage();

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

  //------ Run Button Listeners
  addEventListeners(stadiumButtons);
  addEventListeners(capacityButtons);
  addEventListeners(conditionButtons);
  addEventListeners(coachButtons);
  addEventListeners(propertyButtons);
  addEventListeners(skillCells);
  addEventListeners(playerRows);
  addEventListeners(tacticButtons);
  addEventListeners(pressingButtons);
  addEventListeners(defenceAggressionButtons);
  addEventListeners(midfieldAggressionButtons);
  addEventListeners(attackAggressionButtons);

  //------ Handle Button Clickss
  function handleButtonClick(button) {
    const capacityValues = ['2000', '4000', '6000', '8000'];
    const stadiumValues = ['n', 'e', 's', 'w'];
    const propertyValues = ['pitch', 'hospitality', 'facilities'];

    if (stadiumValues.includes(button.id)){
      resetUpgradeValues(button, stadiumButtons);
    } else if (button.id.startsWith("staff")) {
      setStaffValues(button);
    } else if (propertyValues.includes(button.id)) {
      setPropertyValues(button);
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
    const currentAmount = sessionStorage.getItem('ftw-player-action-amount-' + playerId);
    const newAmount = clickedButton.id;
  
    if (currentAmount === newAmount) {
      sessionStorage.removeItem('ftw-player-action-amount-' + playerId);
    } else {
      sessionStorage.setItem('ftw-player-action-amount-' + playerId, newAmount);
    };

    resetPlayerActions()
    decoratePlayerAmounts();
    decoratePlayerActions();
  };

//-------------------------------------------------------------- Decorate Buttons
  function resetButtonClasses() {
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
      decorateCondition();
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

  function decoratePlayerAmounts() {
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
});
