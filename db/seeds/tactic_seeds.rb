hash = [
  { code: '001', tactic: 1 },
  { code: '002', tactic: 2 },
  { code: '003', tactic: 3 },
  { code: '004', tactic: 4 },
  { code: '005', tactic: 5 },
  { code: '006', tactic: 6 },
  { code: '007', tactic: 1 },
  { code: '008', tactic: 2 },
  { code: '009', tactic: 3 },
  { code: '010', tactic: 4 },
  { code: '011', tactic: 5 },
  { code: '012', tactic: 6 },
  { code: '013', tactic: 1 },
  { code: '014', tactic: 2 },
  { code: '015', tactic: 3 },
  { code: '016', tactic: 4 },
  { code: '017', tactic: 5 },
  { code: '018', tactic: 6 },
  { code: '019', tactic: 1 },
  { code: '020', tactic: 2 },
  { code: '101', tactic: 3 },
  { code: '102', tactic: 4 },
  { code: '103', tactic: 5 },
  { code: '104', tactic: 5 },
  { code: '105', tactic: 1 },
  { code: '106', tactic: 2 },
  { code: '107', tactic: 3 },
  { code: '108', tactic: 4 },
  { code: '109', tactic: 5 },
  { code: '110', tactic: 6 },
  { code: '111', tactic: 1 },
  { code: '112', tactic: 2 },
  { code: '113', tactic: 3 },
  { code: '114', tactic: 4 },
  { code: '115', tactic: 5 },
  { code: '116', tactic: 6 },
  { code: '117', tactic: 1 },
  { code: '118', tactic: 2 },
  { code: '119', tactic: 3 },
  { code: '120', tactic: 4 }
]

hash.each do |hash|
  Tactic.create(
    abbreviation: hash[:code],
    tactics: hash[:tactic]
  )
end
