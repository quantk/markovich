defmodule App.Commands.PlainTextReceiver do
  use App.Commander
  @default_spam_level 3
  @learn_model_limit 100

  def handle(update) do
    update
    |> append_chat_history
    |> learn_model
    |> punch
  end

  defp punch(update) do
    current_message_limit = App.Storage.inc({:message_limit, get_chat_id()})
    Logger.debug("Current message limit: #{current_message_limit}")
    message_limit = App.Storage.get({:spam_level, get_chat_id()}, @default_spam_level) * 3
    if current_message_limit >= message_limit do
      App.Storage.reset({:message_limit, get_chat_id()})
      do_handle(update)
    end

    update
  end

  defp learn_model(update) do
    history_path = App.Utils.get_history_path(get_chat_id())
    model_path = App.Utils.get_model_path(get_chat_id())

    current_model_limit = App.Storage.inc({:model_limit, get_chat_id()})
    Logger.debug("Current message limit: #{current_model_limit}")
    if current_model_limit >= @learn_model_limit do

      Logger.debug("Regenerate model for #{history_path}")
      App.Markov.Model.generate_model(history_path, model_path)
      Logger.debug("Regenerate model for #{history_path} is done")
      App.Storage.reset({:model_limit, get_chat_id()})
    end

    update
  end

  defp append_chat_history(update) do
    dir_path = App.Utils.get_dir_path(get_chat_id())
    history_path = App.Utils.get_history_path(get_chat_id())
    model_path = App.Utils.get_model_path(get_chat_id())

    if update.message.text do
      if !File.exists?(dir_path) do
        File.mkdir_p!(dir_path)
      end

      {:ok, file} = File.open(history_path, [:append])
      IO.binwrite(file, update.message.text <> "\n")
      File.close(file)

      if !File.exists?(model_path) do
        App.Markov.Model.generate_model(history_path, model_path)
      end
    end

    update
  end

  defp do_handle(update) do
    case String.starts_with?(update.message.text, "/") do
      false ->
        model_path = App.Utils.get_model_path(get_chat_id())

        case App.Markov.Model.generate_sentence(model_path) do
          {:ok, message} ->
            message
            |> String.trim(",")
            |> send_message(reply_to_message_id: update.message.message_id)
        end
    end
  end
end
