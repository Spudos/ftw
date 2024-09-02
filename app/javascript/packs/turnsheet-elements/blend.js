function setBlendValues (button, blendButtons) {
  const current_value = sessionStorage.getItem('ftw-blend');

  if (current_value === button.id) {
    sessionStorage.removeItem('ftw-blend');
  } else {
    sessionStorage.setItem('ftw-blend', button.id);
  };
};

export { setBlendValues };