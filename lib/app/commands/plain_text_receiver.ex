defmodule App.Commands.PlainTextReceiver do
  use App.Commander
  @message_limit 20

  def handle(update) do
    current_message_limit = App.Storage.inc(get_chat_id())
    Logger.debug("Current message limit: #{current_message_limit}")

    if current_message_limit >= @message_limit do
      do_handle(update)
    else
      nil
    end
  end

  defp do_handle(update) do
    case String.starts_with?(update.message.text, "/") do
      false ->
        dir_path = App.Utils.get_dir_path(get_chat_id())

        model_path = App.Utils.get_model_path(get_chat_id())
        history_path = App.Utils.get_history_path(get_chat_id())

        if update.message.text do
          if !File.exists?(dir_path) do
            File.mkdir_p!(dir_path)
          end

          {:ok, file} = File.open(history_path, [:append])
          IO.binwrite(file, update.message.text <> "\n")

          if !File.exists?(model_path) do
            App.Markov.Model.generate_model(history_path, model_path)
          end
        end

        case File.stat(history_path) do
          {:ok, %{size: size}} ->
            if size < 500_000 do
              Logger.debug("Regenerate model for #{history_path} #{size}")
              App.Markov.Model.generate_model(history_path, model_path)
              Logger.debug("Regenerate model for #{history_path} is done")
            end
        end

        message_text =
          update.message.text
          |> String.downcase()

        message_text =
          cond do
            String.starts_with?(message_text, "почему") ->
              "потому что"

            String.starts_with?(message_text, "зачем") ->
              "чтобы"

            true ->
              message_text =
                message_text
                |> String.split()
                |> Enum.filter(fn word -> String.length(word) >= 5 end)

              if Enum.empty?(message_text) do
                nil
              else
                Enum.random(message_text)
              end
          end

        case App.Markov.Model.generate_sentence(model_path, message_text) do
          {:ok, message} ->
            if message !== message_text do
              message
              |> String.trim(",")
              |> send_message(reply_to_message_id: update.message.message_id)

              App.Storage.reset(get_chat_id())
            end

          {:error, _} ->
            nil
        end
    end
  end
end
