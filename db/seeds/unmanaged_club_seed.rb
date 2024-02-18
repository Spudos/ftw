def random_number(min, max)
  rand(min..max)
end

Club.create(
  name: 'unmanaged',
  ground_name: 'Stadium',
  stand_n_name: 'n Stand',
  stand_s_name: 's Stand',
  stand_e_name: 'e Stand',
  stand_w_name: 'w Stand',
  stand_n_condition: 0,
  stand_s_condition: 0,
  stand_e_condition: 0,
  stand_w_condition: 0,
  stand_n_capacity: 0,
  stand_s_capacity: 0,
  stand_e_capacity: 0,
  stand_w_capacity: 0,
  pitch: 0,
  hospitality: 0,
  facilities: 0,
  staff_fitness: 0,
  staff_gkp: 0,
  staff_dfc: 0,
  staff_mid: 0,
  staff_att: 0,
  staff_scouts: 0,
  color_primary: 'Black',
  color_secondary: 'Red',
  bank_bal: 0,
  league: 'unmanaged'
)
