function addTransferListener() {
  const radioButtons = document.querySelectorAll('input[name="transfer_type"]');
  radioButtons.forEach(radio => {
    radio.addEventListener('change', handleTransferChange);
  });

  const inputFields = document.querySelectorAll('#transfer_detail input[type="number"]');
  inputFields.forEach(input => {
    input.addEventListener('input', handleTransferChange);
  });

  const radioButtons1 = document.querySelectorAll('input[name="transfer_type_1"]');
  radioButtons1.forEach(radio => {
    radio.addEventListener('change', handleTransfer1Change);
  });

  const inputFields1 = document.querySelectorAll('#transfer_detail_1 input[type="number"]');
  inputFields1.forEach(input => {
    input.addEventListener('input', handleTransfer1Change);
  });

  const radioButtons2 = document.querySelectorAll('input[name="transfer_type_2"]');
  radioButtons2.forEach(radio => {
    radio.addEventListener('change', handleTransfer2Change);
  });

  const inputFields2 = document.querySelectorAll('#transfer_detail_2 input[type="number"]');
  inputFields2.forEach(input => {
    input.addEventListener('input', handleTransfer2Change);
  });

  const radioButtons3 = document.querySelectorAll('input[name="transfer_type_3"]');
  radioButtons3.forEach(radio => {
    radio.addEventListener('change', handleTransfer3Change);
  });

  const inputFields3 = document.querySelectorAll('#transfer_detail_3 input[type="number"]');
  inputFields3.forEach(input => {
    input.addEventListener('input', handleTransfer3Change);
  });
};

function handleTransferChange() {
  const transferType = document.querySelector('input[name="transfer_type"]:checked');
  const transferPlayerId = document.getElementById('transfer_player_id').value;
  const transferBidAmount = document.getElementById('transfer_bid_amount').value;
  const TransferOtherClubId = document.getElementById('transfer_club').value;

  sessionStorage.setItem('ftw-transfer_type', transferType.value);
  sessionStorage.setItem('ftw-transfer_player_id', transferPlayerId);
  sessionStorage.setItem('ftw-transfer_bid_amount', transferBidAmount);
  sessionStorage.setItem('ftw-transfer_club', TransferOtherClubId);
}

function handleTransfer1Change() {
  const transfer1Type = document.querySelector('input[name="transfer_type_1"]:checked');
  const transfer1PlayerId = document.getElementById('transfer_player_id_1').value;
  const transfer1BidAmount = document.getElementById('transfer_bid_amount_1').value;
  const Transfer1OtherClubId = document.getElementById('transfer_club_1').value;

  sessionStorage.setItem('ftw-transfer_type_1', transfer1Type.value);
  sessionStorage.setItem('ftw-transfer_player_id_1', transfer1PlayerId);
  sessionStorage.setItem('ftw-transfer_bid_amount_1', transfer1BidAmount);
  sessionStorage.setItem('ftw-transfer_club_1', Transfer1OtherClubId);
}

function handleTransfer2Change() {
  const transfer2Type = document.querySelector('input[name="transfer_type_2"]:checked');
  const transfer2PlayerId = document.getElementById('transfer_player_id_2').value;
  const transfer2BidAmount = document.getElementById('transfer_bid_amount_2').value;
  const Transfer2OtherClubId = document.getElementById('transfer_club_2').value;

  sessionStorage.setItem('ftw-transfer_type_2', transfer2Type.value);
  sessionStorage.setItem('ftw-transfer_player_id_2', transfer2PlayerId);
  sessionStorage.setItem('ftw-transfer_bid_amount_2', transfer2BidAmount);
  sessionStorage.setItem('ftw-transfer_club_2', Transfer2OtherClubId);
}

function handleTransfer3Change() {
  const transfer3Type = document.querySelector('input[name="transfer_type_3"]:checked');
  const transfer3PlayerId = document.getElementById('transfer_player_id_3').value;
  const transfer3BidAmount = document.getElementById('transfer_bid_amount_3').value;
  const Transfer3OtherClubId = document.getElementById('transfer_club_3').value;

  sessionStorage.setItem('ftw-transfer_type_3', transfer3Type.value);
  sessionStorage.setItem('ftw-transfer_player_id_3', transfer3PlayerId);
  sessionStorage.setItem('ftw-transfer_bid_amount_3', transfer3BidAmount);
  sessionStorage.setItem('ftw-transfer_club_3', Transfer3OtherClubId);
}

export { addTransferListener, handleTransferChange, handleTransfer1Change, handleTransfer2Change, handleTransfer3Change };