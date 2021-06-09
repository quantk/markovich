defmodule App.Commands.UpdateModel do
  use App.Commander
  def handle(update) do
    # Logger.debug("updatemodel command")
    # dir_path = App.Utils.get_dir_path(get_chat_id())

    # model_path = App.Utils.get_model_path(get_chat_id())
    # history_path = App.Utils.get_history_path(get_chat_id())

    # App.Markov.Model.generate_model(history_path, model_path)
  end
end
