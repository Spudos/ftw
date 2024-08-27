//-------------------------------------------------------------- Stand Selection And Club Upgrades
  //------ Reset Upgrade Values On Stand Change
  function resetUpgradeValues(button) {
    sessionStorage.removeItem('ftw-stadium');
    sessionStorage.removeItem('ftw-stadium-amount');
    sessionStorage.removeItem('ftw-condition');

    const standName = document.getElementById('standName');
    const standCapacity = document.getElementById('standCapacity');
    const standCondition = document.getElementById('standCondition');

    standName.innerHTML = "<%= @club.stand_e_name %>";
    standCapacity.innerHTML = "<%= @club.stand_e_capacity %>";
    standCondition.innerHTML = "<%= @club.stand_e_condition %>";
  };

  //------ Set Staff Values
  function setStaffValues(button) {
    if (button.id.startsWith("staff")) {
      const current_value = sessionStorage.getItem('ftw-coach');

      if (current_value === button.id) {
        sessionStorage.removeItem('ftw-coach');
      } else {
        sessionStorage.setItem('ftw-coach', button.id);
      };
    };
  };

  //------ Set Property Values
  function setPropertyValues(button) {
    const propertyToCheck = ['pitch', 'hospitality', 'facilities'];

    if (propertyToCheck.includes(button.id)) {
      const current_value = sessionStorage.getItem('ftw-property');

      if (current_value === button.id) {
        sessionStorage.removeItem('ftw-property');
      } else {
        sessionStorage.setItem('ftw-property', button.id);
      };
    };
  };

  //------ Set Condition Values
  function setConditionValues(button) {
    const successButton = Array.from(stadiumButtons).find(button => button.classList.contains('btn-success'));

    if (button.id === 'condition') {
      current_value = sessionStorage.getItem('ftw-condition');

      if (current_value === 'stand_' + successButton.id + '_condition') {
        sessionStorage.removeItem('ftw-condition');
      } else {
        sessionStorage.setItem('ftw-condition', 'stand_' + successButton.id + '_condition');
      };
    };
  };

  //------ Set Stadium Capacity Input Values
  function setCapacityValues(button) {
    const upgradeValues = ['2000', '4000', '6000', '8000'];
    const successButton = Array.from(stadiumButtons).find(button => button.classList.contains('btn-success'));

    if (upgradeValues.includes(button.id)) {
      current_upgrade = sessionStorage.getItem('ftw-stadium');
      current_amount = sessionStorage.getItem('ftw-stadium-amount');

      if (current_upgrade === 'stand_' + successButton.id + '_capacity' && current_amount === button.id) {
        sessionStorage.removeItem('ftw-stadium');
        sessionStorage.removeItem('ftw-stadium-amount');
      } else {
        sessionStorage.setItem('ftw-stadium', 'stand_' + successButton.id + '_capacity');
        sessionStorage.setItem('ftw-stadium-amount', button.id);
      };
    };
  };

export { resetUpgradeValues, setStaffValues, setPropertyValues, setConditionValues, setCapacityValues };