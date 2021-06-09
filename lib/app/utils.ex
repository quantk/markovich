defmodule App.Utils do
  @data_dir "data"

  def get_data_dir, do: @data_dir

  def get_history_path(chat_id) do
    dir_path = chat_id
    |> get_dir_path

    Path.join([dir_path, "chat_history.txt"])
  end

  def get_model_path(chat_id) do
    dir_path = chat_id
    |> get_dir_path

    Path.join([dir_path, "chat_model.data"])
  end

  def get_dir_path(chat_id), do: Path.join([@data_dir, Integer.to_string(chat_id)])
end
