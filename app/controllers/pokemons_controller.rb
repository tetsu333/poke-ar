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
    return redirect_to pokemons_path, alert: "既に登録済みです" if Pokemon.find_by(pokedex_number: pokemon_params[:pokedex_number])
    @pokemon, message = PokemonFetchJob.perform_now(pokemon_params[:pokedex_number])
    if @pokemon.persisted?
      redirect_to pokemons_path, notice: "#{@pokemon.name}が登録されました。"
    else
      redirect_to pokemons_path, alert: message
    end
  end

  # PATCH/PUT /pokemons/1
  def update
    @pokemon, message = PokemonFetchJob.perform_now(pokemon_params[:pokedex_number])
    if @pokemon.persisted?
      redirect_to pokemons_path, notice: "新しい#{@pokemon.name}に交換されました。"
    else
      redirect_to pokemons_path, alert: message
    end
  end

  # DELETE /pokemons/1
  def destroy
    @pokemon.destroy!
    redirect_to pokemons_path, notice: "#{@pokemon.name}を逃しました。"
  end

  private
    def set_pokemon
      @pokemon = Pokemon.find(params[:id])
    end

    def pokemon_params
      params.require(:pokemon).permit(:pokedex_number, :name, :image_url)
    end
end
