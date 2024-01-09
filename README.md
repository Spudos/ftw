# README

Seed files have been created to geenrate all the data required to run the game EXCEPT FOR fixtures.

All the seed files can be run with a single rails db:seed terminal command

At present, to play a game you carry out the following steps:

1. In the fixtures admin option, create a fixture with a home and away team using the code of the team which will be from 001 to 020 for premier league teams and 101 to 120 for championship teams.  set the week to 0 and the comp to friendly.

2. You then need to create a team for those two clubs.  Go to the admin menu and select turnsheets.  Then select the club by name and create new turnsheet.   Set the week to 0 and select a team.  Do not pick a player twice, player 1 must be a goalkeeper but other players can be pick at random.  you must have one dfc, one mid and one att.  Validation for all these elements will be added later.  Finally pick a tactic from the dropdown and save the turnsheet.

3. Back in the turnsheets veiw, run process turnsheets

4. Select View Fixtures from the admin menu and select week 0.  Press Run All Games

5. Select week 0 again and you will see the results of the game.  Press show result to see the match report.  You will now be able to see populated club information.
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Things to improve

1. controllers must be simpler
2. all business logic in models (not necessarily one file, but called from within models via callback methods and similar)
3. full names for variables
4. remove all business logic global variables and replace them with method returns and method arguments
5. commentry report -> this is single responsibility, so put it in one class which can also then be tested easily
6. use Threads to run #initialize_min_by_min in parallel
7. measure with @file.write("#{Time.now}") to find out slow parts before you optimise
8. start breaking things down into testable classes -> all related methods could go to one class, aim for one to two public methods per class so that you can easily test input and output from such classes
9. aim for methods lenght of 10 lines top
class EventCommentary
  def initialize(event, commentary, type)
    @event = event
    @commentary = commentary
    @type = type
  end

  def formatted_commentary
    {
      event: @event.capitialize,
      commentary: right_format_for_commentary
    }
  end

  private

  def right_format_for_commentary
    case @type
    when 'home_goal': resolve_home_goal_commentry
    when 'good_chance': resolve_good_chance...
  end

  def resolve_home_goal_commentry
    @commentary.gsub(...)
  end
end
