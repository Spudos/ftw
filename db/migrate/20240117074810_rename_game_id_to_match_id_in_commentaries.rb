class RenameGameIdToMatchIdInCommentaries < ActiveRecord::Migration[7.0]
    def change
      rename_column :commentaries, :game_id, :match_id
    end
end
