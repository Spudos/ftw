class Turn::ArticleUpdates
  attr_reader :week

  def initialize(week)
    @week = week
  end

  def call
    top_perf_player
    top_goals_player
    top_assists_player
    highest_bank_balance
    highest_fanbase
    highest_fan_happiness
  end

  private

  def top_perf_player
    players = Player.order(average_performance: :desc).limit(4)

    Article.create(
      week:,
      club_id: players[0][:club_id],
      image: 'player.jpg',
      article_type: 'Player',
      headline: "Imperious #{players[0][:name]}!",
      sub_headline: "The #{players[0][:position]} is currently being proven to be the most in-form player in football",
      article: "#{players[0][:name]} is in great form at the moment with an average performance rating of #{players[0][:average_performance]}.  He has been performing very well for his club, #{Club.find_by(id: players[0][:club_id])&.name}, cementing his position as their best performing #{players[0][:position]} and the best performing player around today.  Other players who are in great form include #{players[1][:position]} #{players[1][:name]}, #{players[2][:position]} #{players[2][:name]} and #{players[3][:position]} #{players[3][:name]}."
      )
  end

  def top_goals_player
    players = Player.order(total_goals: :desc).limit(4)

    Article.create(
      week:,
      club_id: players[0][:club_id],
      image: 'goal.jpg',
      article_type: 'Player',
      headline: "Deadly #{players[0][:name]}!",
      sub_headline: "No one has scored more than the #{players[0][:position]} so far this season",
      article: "#{players[0][:name]} is in great form at the moment scoring #{players[0][:total_goals]} goals.  He has been performing very well for his club, #{Club.find_by(id: players[0][:club_id])&.name}, banging in more goals than anyone else in the world. The #{players[0][:position]} will be turning a few heads amongst managers around the world.  Other players who are in great form include #{players[1][:position]} #{players[1][:name]} with #{players[1][:total_goals]} goals, #{players[2][:position]} #{players[2][:name]} with #{players[2][:total_goals]} goals and #{players[3][:position]} #{players[3][:name]} with #{players[3][:total_goals]} goals."
      )
  end

  def top_assists_player
    players = Player.order(total_assists: :desc).limit(4)

    Article.create(
      week:,
      club_id: players[0][:club_id],
      image: 'assist.jpg',
      article_type: 'Player',
      headline: "Assist King #{players[0][:name]}!",
      sub_headline: "No one has assisted more than the #{players[0][:position]} so far this season",
      article: "#{players[0][:name]} is in great form at the moment assisting #{players[0][:total_assists]} goals.  He has been performing very well for his club, #{Club.find_by(id: players[0][:club_id])&.name}, chipping in with more assists than anyone else in the world. The #{players[0][:position]} will be interesting to managers who need a creative player.  Other players who are in great form include #{players[1][:position]} #{players[1][:name]} with #{players[1][:total_assists]} assists, #{players[2][:position]} #{players[2][:name]} with #{players[2][:total_assists]} assists and #{players[3][:position]} #{players[3][:name]} with #{players[3][:total_assists]} assists."
      )
  end

  def highest_bank_balance
    clubs = Club.order(bank_bal: :desc).limit(4)

    Article.create(
      week:,
      club_id: clubs[0][:id],
      image: 'cash.jpg',
      article_type: 'Club',
      headline: "Super Rich #{clubs[0][:name]}!",
      sub_headline: "No one currently has more money than #{clubs[0][:league]}",
      article: "#{clubs[0][:name]} could be ready to splash the cash after finding themselves with #{clubs[0][:bank_bal]}.  The club will be looking to use the money wisely but this might prove difficult when other teams become aware of their vast wealth.  Other well off clubs include #{clubs[1][:name]} from #{clubs[1][:league]}, #{clubs[2][:name]} from #{clubs[2][:league]} and #{clubs[3][:name]} from #{clubs[3][:league]}."
      )
  end

  def highest_fanbase
    clubs = Club.order(fanbase: :desc).limit(4)

    Article.create(
      week:,
      club_id: clubs[0][:id],
      image: 'fans.jpg',
      article_type: 'Club',
      headline: "World Giants #{clubs[0][:name]}?!",
      sub_headline: "#{clubs[0][:name]} estimated to have the biggest fanbase in the world",
      article: "#{clubs[0][:name]} are the most popular team in the world with a fanbase of #{clubs[0][:fanbase]}.  The club will be looking at how they can utilise their popularity and are considering stadium increases.  Other well supported clubs include #{clubs[1][:name]} from #{clubs[1][:league]}, #{clubs[2][:name]} from #{clubs[2][:league]} and #{clubs[3][:name]} from #{clubs[3][:league]}."
      )
  end

  def highest_fan_happiness
    clubs = Club.order(fan_happiness: :desc).limit(4)

    Article.create(
      week:,
      club_id: clubs[0][:id],
      image: 'fans1.jpg',
      article_type: 'Club',
      headline: "#{clubs[0][:name]} Happy Clappers?!",
      sub_headline: "#{clubs[0][:name]} estimated to have the happiest fanbase in the world",
      article: "#{clubs[0][:name]} fans are glad to be alive with a fan happiness rating of #{clubs[0][:fan_happiness]}.  The club try hardto please their fans with good performances and transfer signings .  Other cheerful supporter groups include #{clubs[1][:name]} from #{clubs[1][:league]}, #{clubs[2][:name]} from #{clubs[2][:league]} and #{clubs[3][:name]} from #{clubs[3][:league]}."
      )
  end
end
