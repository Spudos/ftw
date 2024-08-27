//------ Handle Skill Clicks
function handleSkillClick(button) {
  const row = button.parentNode;

  if (button.classList.contains('potential')) {
    alert('That skill has been trained to its maximum potential.');
    return;
  } else if (button.classList.contains('inferior')) {
    alert('Your coach is not skilled enough to train that skill.');
    return;
  }

  const playerId = row.querySelector('#player_id').innerHTML;

  const positionDetail = row.querySelector('#position').innerHTML;
  const position = positionDetail.slice(0, 3).toLowerCase();
  
  const newKey = 'ftw-coach-' + position + '-' + playerId;

  const existingKey = Object.keys(sessionStorage).find(key => key.startsWith('ftw-coach') && key.includes(position));
  const existingValue = sessionStorage.getItem(existingKey);
  const existingPosition = Object.keys(sessionStorage).find(key => key.includes(position));

  if (existingKey == newKey && existingValue == button.id) {
    sessionStorage.removeItem(existingKey);
  } else if (existingPosition) {
    sessionStorage.removeItem(existingKey);
    sessionStorage.setItem(newKey, button.id);
  } else {
    sessionStorage.setItem(newKey, button.id);
  };
};

export { handleSkillClick };