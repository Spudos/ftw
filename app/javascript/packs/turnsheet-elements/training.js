//------ Handle Skill Clicks
function handleSkillClick(button) {
  const row = button.parentNode;
  const playerId = row.querySelector('#player_id').innerHTML;
  const positionDetail = row.querySelector('#position').innerHTML;
  const position = positionDetail.slice(0, 3).toLowerCase();
  const idKey = 'ftw-coach-' + position + '-id';
  const skillKey = 'ftw-coach-' + position + '-skill';

  if (sessionStorage.getItem(idKey) === playerId && sessionStorage.getItem(skillKey) === button.id) {
    sessionStorage.removeItem(idKey);
    sessionStorage.removeItem(skillKey);
  } else {
    sessionStorage.setItem(idKey, playerId);
    sessionStorage.setItem(skillKey, button.id);
  };
};

export { handleSkillClick };