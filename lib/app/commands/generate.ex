defmodule App.Commands.Generate do
  use App.Commander
  def handle(update) do
    Logger.debug("generate command")
    dir_path = App.Utils.get_dir_path(get_chat_id())

    model_path = App.Utils.get_model_path(get_chat_id())
    history_path = App.Utils.get_history_path(get_chat_id())

    if !File.exists?(dir_path) do
      File.mkdir_p!(dir_path)
    end

    if !File.exists?(model_path) do
      App.Markov.Model.generate_model(history_path, model_path)
    end

    case App.Markov.Model.generate_sentence(model_path, nil) do
      {:ok, message} ->
        if message !== update.message.text do
          message
          |> String.trim(",")
          |> send_message(reply_to_message_id: update.message.message_id)
        end
      {:error, _} ->
        nil
    end
  end
end
