defmodule App.Storage do
  use GenServer
  require Logger

  def start_link do
    Logger.log(:info, "Started storage")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    CubDB.start_link(data_dir: Path.join([App.Utils.get_data_dir(), "cubdb"]))
  end

  def handle_cast({:put, key, value}, db) do
    CubDB.put(db, key, value)

    {:noreply, db}
  end

  def handle_call({:get, key}, _from, db) do
    {:reply, CubDB.get(db, key), db}
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def inc(key) do
    current_value = (get(key) || 0) + 1
    put(key, current_value)
    current_value
  end

  def reset(key) do
    put(key, 0)
  end
end
