defmodule App.Commands.Start do
  use App.Commander
  def handle(update) do
    Logger.debug("start command")
    dir_path = App.Utils.get_dir_path(get_chat_id())

    model_path = App.Utils.get_model_path(get_chat_id())
    history_path = App.Utils.get_history_path(get_chat_id())
    Logger.log(:debug, dir_path)

    if !File.exists?(dir_path) do
      File.mkdir_p!(dir_path)
    end

    if !File.exists?(history_path) do
      File.touch(history_path)
    end

    if !File.exists?(model_path) do
      File.touch(model_path)
      App.Markov.Model.generate_model(history_path, model_path)
    end
  end
end
