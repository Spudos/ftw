//-------------------------------------------------------------- Tactic Selection
function setTacticValue(button) {
  sessionStorage.setItem('ftw-tactic', button.id);
};

function setPressValue(button) {
  sessionStorage.setItem('ftw-press', button.id);
};

function setDefenceAggression(button) {
  sessionStorage.setItem('ftw-defence-aggression', button.id);
};

function setMidfieldAggression(button) {
  sessionStorage.setItem('ftw-midfield-aggression', button.id);
};

function setAttackAggression(button) {
  sessionStorage.setItem('ftw-attack-aggression', button.id);
};

export { setTacticValue, setPressValue, setDefenceAggression, setMidfieldAggression, setAttackAggression };