class FixturesController < ApplicationController
  require 'csv'

  def index
    @fixtures = Fixture.all
  end

  def show
    @fixtures = Fixture.find_by(id: params[:id])
  end

  def new
    @fixtures = Fixture.new
  end

  def edit
    @fixtures = Fixture.find_by(id: params[:id])
  end

  def create
    @fixtures = Fixture.new(fixtures_params)

    respond_to do |format|
      if @fixtures.save
        format.html { redirect_to fixtures_path, notice: "Fixture was successfully created." }
        format.json { render :show, status: :created, location: @fixtures }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fixtures.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @fixtures = Fixture.find_by(id: params[:id])

    respond_to do |format|
      if @fixtures.update(fixtures_params)
        format.html { redirect_to fixtures_path, notice: "Fixture was successfully updated." }
        format.json { render :show, status: :ok, location: @fixtures }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fixtures.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    fixture = Fixture.find_by(id: params[:id])

    fixture.destroy

    respond_to do |format|
      format.html { redirect_to fixtures_url, notice: "Fixture was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    begin
      CSV.foreach(params[:file].path, headers: true) do |row|
        fixture = Fixture.find_or_initialize_by(week_number: row["week_number"], home: row["home"], away: row["away"], comp: row["comp"])
        fixture.save unless fixture.persisted?
      end
      redirect_to request.referrer, notice: "CSV imported successfully!"
    rescue StandardError => e
      redirect_to request.referrer, alert: "Error importing CSV: #{e.message}"
    end
  end

  private

  def fixtures_params
    params.require(:fixture).permit(:id, :week_number, :home, :away, :comp)
  end
end