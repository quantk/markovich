defmodule App.Commands.ResetData do
  use App.Commander
  def handle(update) do
    Logger.debug("resetdata command")
    File.rm_rf!(App.Utils.get_dir_path(get_chat_id()))
  end
end
