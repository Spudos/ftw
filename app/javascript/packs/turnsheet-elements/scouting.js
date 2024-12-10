function addScoutingListener() {
  const radioButtons = document.querySelectorAll('input[name="position"]');
  radioButtons.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons1 = document.querySelectorAll('input[name="total_skill"]');
  radioButtons1.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons2 = document.querySelectorAll('input[name="age"]');
  radioButtons2.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons3 = document.querySelectorAll('input[name="skills"]');
  radioButtons3.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons4 = document.querySelectorAll('input[name="loyalty"]');
  radioButtons4.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons5 = document.querySelectorAll('input[name="potential_skill"]');
  radioButtons5.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons6 = document.querySelectorAll('input[name="consistency"]');
  radioButtons6.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons7 = document.querySelectorAll('input[name="recovery"]');
  radioButtons7.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });

  const radioButtons8 = document.querySelectorAll('input[name="star"]');
  radioButtons8.forEach(radio => {
    radio.addEventListener('change', handleScoutingChange);
  });
};

function handleScoutingChange(event) {
  sessionStorage.setItem(`ftw-scouting-${event.target.name}`, event.target.value);
}

export { addScoutingListener };