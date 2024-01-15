# README

Seed files have been created to geenrate all the data required to run the game EXCEPT FOR fixtures.

All the seed files can be run with a single rails db:seed terminal command

At present, to play a game you carry out the following steps:

1. In the fixtures admin option, create a fixture with a home and away team using the code of the team which will be from 001 to 020 for premier league teams and 101 to 120 for championship teams.  set the week to 0 and the comp to friendly.  pick a match id higher 760, this will be automated eventually.

2. You then need to create a team for those two clubs.  Go to the admin menu and select turnsheets.  Then select the club by name and create new turnsheet.   Set the week to 0 and select a team.  Do not pick a player twice, player 1 must be a goalkeeper but other players can be pick at random.  you must have one dfc, one mid and one att.  Validation for all these elements will be added later.  Finally pick a tactic from the dropdown and save the turnsheet.

3. Back in the turnsheets veiw, run process turnsheets

4. Select View Fixtures from the admin menu and select week 0.  Press Run All Games

5. Select week 0 again and you will see the results of the game.  Press who result to see the match report.  You will now be able to see club and league information.