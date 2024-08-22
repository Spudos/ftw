const club = <%= @club.to_json.html_safe %>;
const rows = document.querySelectorAll('tr[class]');
const selection = <%= @selection.to_json.html_safe %>;

rows.forEach(function(row) {
  const skillCells = row.querySelectorAll('td.skill'); 
  const position = row.classList[0];
  const staffKey = 'staff_' + position;

  skillCells.forEach(function(cell) {
    if (cell.innerHTML >= club[staffKey]) {
      cell.classList.add('inferior-coach');
    }
  });
  
  const playerIdCell = row.querySelector('td.player_id');
  const playerId = playerIdCell ? playerIdCell.innerHTML : null;
  const player = selection.find(function(player) {
    return player.id == playerId;
  });
  
  skillCells.forEach(function(cell) {
    const potentialCheck = 'potential_' + cell.id + '_coached';
    console.log(potentialCheck);
    console.log(player[potentialCheck]);

    if (player[potentialCheck] == true) {
      cell.classList.add('potential-coached');
    }
  });

  skillCells.forEach(function(cell) {
    cell.addEventListener('click', function() {

    const playerIdCell = cell.closest('tr').querySelector('td.player_id');
    const playerId = playerIdCell ? playerIdCell.innerHTML : 'Unknown Player ID';
    const skillId = cell.id;

    console.log(`Skill ID: ${skillId}, Player ID: ${playerId}`);
    cell.classList.add('coached');

  });
  });
});  