class PokemonsController < ApplicationController
  before_action :set_pokemon, only: %i[ show edit update destroy ]

  # GET /pokemons
  def index
    @pokemons = Pokemon.all.order(:pokedex_number)
  end

  # GET /pokemons/1
  def show
    @useAframe = true
  end

  # GET /pokemons/new
  def new
    @pokemon = Pokemon.new
  end

  # GET /pokemons/1/edit
  def edit
  end

  # POST /pokemons
  def create
    @pokemon = PokemonFetchJob.perform_now(pokemon_params[:pokedex_number])
    if @pokemon.persisted?
      redirect_to pokemons_path, notice: "#{@pokemon.name}が登録されました。"
    else
      redirect_to pokemons_path, alert: "エラーが発生しました。"
    end
  end

  # PATCH/PUT /pokemons/1
  def update
    if @pokemon.update(pokemon_params)
      redirect_to @pokemon, notice: "Pokemon was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pokemons/1
  def destroy
    @pokemon.destroy!
    redirect_to pokemons_url, notice: "Pokemon was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pokemon
      @pokemon = Pokemon.find(params[:id])
    end

    def pokemon_params
      params.require(:pokemon).permit(:pokedex_number, :name, :image_url)
    end
end
