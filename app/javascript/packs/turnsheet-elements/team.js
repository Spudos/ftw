//-------------------------------------------------------------- Team Selection
let gkpCount = 0;
let dfcCount = 0;
let midCount = 0;
let attCount = 0;

function handlePlayerClick(button) {
  const itemsPreClick = {};

  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
      
    if (key && key.startsWith('ftw-selection')) {
      itemsPreClick[key] = sessionStorage.getItem(key);
    };
  };

  const selectedPlayer = []
  Object.entries(itemsPreClick).forEach(([key, value]) => {
    selectedPlayer.push(key);
  });

  if (selectedPlayer.includes('ftw-selection-' + button.dataset.playerId)) {
    sessionStorage.removeItem('ftw-selection-' + button.dataset.playerId);
  } else {
    sessionStorage.setItem('ftw-selection-' + button.dataset.playerId, button.dataset.playerPosition);
  };

  teamValidations();
  formationUpdate();
};

function teamValidations() {
  const itemsPostClick = {};

  for (let i = 0; i < sessionStorage.length; i++) {
    const key = sessionStorage.key(i);
      
    if (key && key.startsWith('ftw-selection')) {
      itemsPostClick[key] = sessionStorage.getItem(key);
    };
  };

  const selectedPositions = []
  Object.entries(itemsPostClick).forEach(([key, value]) => {
    selectedPositions.push(value);
  });

  gkpCount = selectedPositions.filter(position => position === 'gkp').length;
  dfcCount = selectedPositions.filter(position => position === 'dfc').length;
  midCount = selectedPositions.filter(position => position === 'mid').length;
  attCount = selectedPositions.filter(position => position === 'att').length;

  const teamWarning = document.querySelector('.invalid_team');

  if (selectedPositions.length != 11 || gkpCount < 1 || gkpCount > 1 || dfcCount < 1 || midCount < 1 || attCount < 1) {
    if (!submitButton.classList.contains('disabled')) {
      submitButton.classList.add('disabled');
    };
    teamWarning.classList.remove('d-none');
  } else {
    submitButton.classList.remove('disabled');
    teamWarning.classList.add('d-none');
  };
};

function formationUpdate() {
  const gkpSelected = document.querySelector('#gkpCount');
  const dfcSelected = document.querySelector('#dfcCount');
  const midSelected = document.querySelector('#midCount');
  const attSelected = document.querySelector('#attCount');

  gkpSelected.innerText = gkpCount;
  dfcSelected.innerText = dfcCount;
  midSelected.innerText = midCount;
  attSelected.innerText = attCount;
}

export { handlePlayerClick, formationUpdate };