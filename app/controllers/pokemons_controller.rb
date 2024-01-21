class PokemonsController < ApplicationController
  before_action :current_user
  before_action :set_pokemon, only: %i[ show edit update destroy ]

  def index
    @pokemons = Pokemon.all.order(:pokedex_number)
  end

  def show
    @useAframe = true
  end

  def new
    @pokemon = Pokemon.new
  end

  def edit
  end

  def create
    return redirect_to new_pokemon_path, alert: "既に登録済みです" if Pokemon.find_by(pokedex_number: pokemon_params[:pokedex_number])
    @pokemon, message = PokemonFetchJob.perform_now(pokemon_params[:pokedex_number])
    if @pokemon.persisted?
      redirect_to pokemons_path, notice: "#{@pokemon.name}が登録されました"
    else
      redirect_to new_pokemon_path, alert: message
    end
  end

  def update
    @pokemon, message = PokemonFetchJob.perform_now(pokemon_params[:pokedex_number])
    if @pokemon.persisted?
      redirect_to pokemons_path, notice: "新しい#{@pokemon.name}に交換されました"
    else
      redirect_to pokemons_path, alert: message
    end
  end

  def destroy
    @pokemon.destroy!
    redirect_to pokemons_path, notice: "#{@pokemon.name}を逃しました"
  end

  private
    def set_pokemon
      @pokemon = Pokemon.find(params[:id])
    end

    def pokemon_params
      params.require(:pokemon).permit(:pokedex_number, :name, :image_url)
    end

    def current_user
      if session[:user_id]
        @user = User.find(session[:user_id])
      else
        redirect_to new_sessions_path, alert: "ログインする必要があります。"
      end
    end
end
