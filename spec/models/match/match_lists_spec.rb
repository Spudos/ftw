require 'rails_helper'
require 'pry'

RSpec.describe Match::MatchLists, type: :model do
  describe 'match lists' do
    it 'should return the home and away teams and top 5 performers for each' do
      final_squad = [
        {
          match_performance: 45,
          player_position: 'gkp',
          club: '001',
          player_id: 401
        },
        {
          match_performance: 50,
          player_position: 'dfc',
          club: '001',
          player_id: 402
        },
        {
          match_performance: 55,
          player_position: 'mid',
          club: '001',
          player_id: 403
        },
        {
          match_performance: 60,
          player_position: 'att',
          club: '001',
          player_id: 404
        },
        {
          match_performance: 65,
          player_position: 'att',
          club: '001',
          player_id: 405
        },
        {
          match_performance: 70,
          player_position: 'att',
          club: '001',
          player_id: 406
        },
        {
          match_performance: 42,
          player_position: 'gkp',
          club: '002',
          player_id: 501
        },
        {
          match_performance: 50,
          player_position: 'dfc',
          club: '002',
          player_id: 502
        },
        {
          match_performance: 30,
          player_position: 'mid',
          club: '002',
          player_id: 503
        },
        {
          match_performance: 35,
          player_position: 'mid',
          club: '002',
          player_id: 504
        },
        {
          match_performance: 40,
          player_position: 'att',
          club: '002',
          player_id: 505
        },
        {
          match_performance: 45,
          player_position: 'att',
          club: '002',
          player_id: 506
        }
      ]
      home_top, away_top, home_list, away_list = Match::MatchLists.new(final_squad).call

      expect(home_top).to contain_exactly(
        {
          player_id: 406,
          player_position: 'att',
          match_performance: 70
        },
        {
          player_id: 405,
          player_position: 'att',
          match_performance: 65
        },
        {
          player_id: 404,
          player_position: 'att',
          match_performance: 60
        },
        {
          player_id: 403,
          player_position: 'mid',
          match_performance: 55
        },
        {
          player_id: 402,
          player_position: 'dfc',
          match_performance: 50
        }
      )

      expect(away_top).to contain_exactly(
        {
          player_id: 502,
          player_position: 'dfc',
          match_performance: 50
        },
        {
          player_id: 506,
          player_position: 'att',
          match_performance: 45
        },
        {
          player_id: 505,
          player_position: 'att',
          match_performance: 40
        },
        {
          player_id: 504,
          player_position: 'mid',
          match_performance: 35
        },
        {
          player_id: 503,
          player_position: 'mid',
          match_performance: 30
        }
      )

      expect(home_list).to contain_exactly(
        {
          match_performance: 45,
          player_position: 'gkp',
          player_id: 401
        },
        {
          match_performance: 50,
          player_position: 'dfc',
          player_id: 402
        },
        {
          match_performance: 55,
          player_position: 'mid',
          player_id: 403
        },
        {
          match_performance: 60,
          player_position: 'att',
          player_id: 404
        },
        {
          match_performance: 65,
          player_position: 'att',
          player_id: 405
        },
        {
          match_performance: 70,
          player_position: 'att',
          player_id: 406
        }
      )

      expect(away_list).to contain_exactly(
        {
          match_performance: 42,
          player_position: 'gkp',
          player_id: 501
        },
        {
          match_performance: 50,
          player_position: 'dfc',
          player_id: 502
        },
        {
          match_performance: 30,
          player_position: 'mid',
          player_id: 503
        },
        {
          match_performance: 35,
          player_position: 'mid',
          player_id: 504
        },
        {
          match_performance: 40,
          player_position: 'att',
          player_id: 505
        },
        {
          match_performance: 45,
          player_position: 'att',
          player_id: 506
        }
      )
    end
  end
end
