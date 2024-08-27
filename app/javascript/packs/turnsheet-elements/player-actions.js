//-------------------------------------------------------------- Player Actions
function setPlayerAction(clickedButton, array) {
  const playerId = clickedButton.dataset.playerId;
  const currentAction = sessionStorage.getItem('ftw-player-action-' + playerId);
  const newAmount = clickedButton.id;

  if (currentAction === newAmount) {
    sessionStorage.removeItem('ftw-player-action-' + playerId);
  } else {
    sessionStorage.setItem('ftw-player-action-' + playerId, newAmount);
  };
};

function setPlayerAmount(clickedButton, array) {
  const playerId = clickedButton.dataset.playerId;
  const currentAmount = sessionStorage.getItem('ftw-player-action-amount-' + playerId);
  const newAmount = clickedButton.id;

  if (currentAmount === newAmount) {
    sessionStorage.removeItem('ftw-player-action-amount-' + playerId);
  } else {
    sessionStorage.setItem('ftw-player-action-amount-' + playerId, newAmount);
  };
};

export { setPlayerAction, setPlayerAmount };