class TurnsheetsController < ApplicationController
  before_action :set_turnsheet, only: %i[ show edit update destroy ]

  # GET /turnsheets or /turnsheets.json
  def index
    @turnsheets = Turnsheet.all
  end

  # GET /turnsheets/1 or /turnsheets/1.json
  def show
  end

  # GET /turnsheets/new
  def new
    @turnsheet = Turnsheet.new
  end

  # GET /turnsheets/1/edit
  def edit
  end

  # POST /turnsheets or /turnsheets.json
  def create
    @turnsheet = Turnsheet.new(turnsheet_params)

    respond_to do |format|
      if @turnsheet.save
        format.html { redirect_to turnsheet_url(@turnsheet), notice: "Turnsheet was successfully created." }
        format.json { render :show, status: :created, location: @turnsheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turnsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turnsheets/1 or /turnsheets/1.json
  def update
    respond_to do |format|
      if @turnsheet.update(turnsheet_params)
        format.html { redirect_to turnsheet_url(@turnsheet), notice: "Turnsheet was successfully updated." }
        format.json { render :show, status: :ok, location: @turnsheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turnsheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turnsheets/1 or /turnsheets/1.json
  def destroy
    @turnsheet.destroy

    respond_to do |format|
      format.html { redirect_to turnsheets_url, notice: "Turnsheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def process_turnsheet
    Turnsheet.find_each do |turnsheet|
      next if turnsheet.processed.present?

      turnsheet.save # Save the Turnsheet record first

      Selection.where(club: turnsheet.club).destroy_all

      Selection.create([
        { club: turnsheet.club, player_id: turnsheet.player_1, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_2, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_3, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_4, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_5, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_6, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_7, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_8, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_9, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_10, turnsheet: turnsheet },
        { club: turnsheet.club, player_id: turnsheet.player_11, turnsheet: turnsheet }
      ])

      if turnsheet.coach_upg.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: turnsheet.coach_upg, turnsheet: turnsheet })
      end

      if turnsheet.train_gkp.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_gkp, var3: turnsheet.train_gkp_skill, turnsheet: turnsheet })
      end

      if turnsheet.train_dfc.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_dfc, var3: turnsheet.train_dfc_skill, turnsheet: turnsheet })
      end

      if turnsheet.train_mid.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_mid, var3: turnsheet.train_mid_skill, turnsheet: turnsheet })
      end

      if turnsheet.train_att.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: 'train', var2: turnsheet.train_att, var3: turnsheet.train_att_skill, turnsheet: turnsheet })
      end

      if turnsheet.stad_upg.present?
        Turn.create({ week: turnsheet.week, club: turnsheet.club, var1: turnsheet.stad_upg, var2: turnsheet.stad_amt, var3: turnsheet.val, turnsheet: turnsheet })
      end

      turnsheet.update(processed: DateTime.now)
    end
  end

  private

  def set_turnsheet
    @turnsheet = Turnsheet.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def turnsheet_params
    params.require(:turnsheet).permit(:week, :club, :manager, :email, :player_1, :player_2, :player_3, :player_4, :player_5, :player_6,:player_7, :player_8, :player_9, :player_10, :player_11, :stad_upg, :coach_upg, :train_gkp, :train_gkp_skill, :train_dfc, :train_dfc_skill, :train_mid, :train_mid_skill, :train_att, :train_att_skill, :stad_amt, :coach_upg, :val)
  end
end
