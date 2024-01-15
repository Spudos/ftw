class FixturesController < ApplicationController
  def index
    @fixtures = Fixtures.all
  end

  def show
    @fixtures = Fixtures.find_by(id: params[:id])
  end

  def new
    @fixtures = Fixtures.new
  end

  def edit
    @fixtures = Fixtures.find_by(id: params[:id])
  end

  def create
    @fixtures = Fixtures.new(fixtures_params)

    respond_to do |format|
      if @fixtures.save
        format.html { redirect_to fixture_url(@fixtures), notice: "Fixture was successfully created." }
        format.json { render :show, status: :created, location: @fixtures }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fixtures.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @fixtures = Fixtures.find_by(id: params[:id])

    respond_to do |format|
      if @fixtures.update(fixtures_params)
        format.html { redirect_to fixtures_url(@fixtures), notice: "Fixture was successfully updated." }
        format.json { render :show, status: :ok, location: @fixtures }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fixtures.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    fixture = Fixtures.find_by(id: params[:id])

    fixture.destroy

    respond_to do |format|
      format.html { redirect_to fixtures_url, notice: "Fixture was successfully destroyed." }
      format.json { head :no_content }
    end
  end
end

private

def fixtures_params
  params.require(:fixtures).permit(:id, :week_number, :home, :away, :comp)
end
