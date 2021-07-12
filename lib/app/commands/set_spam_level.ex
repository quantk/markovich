defmodule App.Commands.SetSpamLevel do
  use App.Commander

  def handle(update) do
    [_command | args] = String.split(update.message.text, " ")
    do_handle(args, get_chat_id(), update)
  end

  defp do_handle([level | []], chat_id, update) when level > 0 and level <= 10 do
    App.Storage.put({:spam_level, chat_id}, level)
    send_message("Ок, теперь буду флудить на #{level}")
    {:ok}
  end
  defp do_handle(_, _, update) do
    send_message("Чет не то :/")
    {:ok}
  end
end
