defmodule App.Commands do
  use App.Router
  use App.Commander

  command "start", App.Commands.Start, :handle
  command "updatemodel", App.Commands.UpdateModel, :handle
  command "generate", App.Commands.Generate, :handle
  command "resetdata", App.Commands.ResetData, :handle
  command "setspamlvl", App.Commands.SetSpamLevel, :handle
  message App.Commands.PlainTextReceiver, :handle
end
