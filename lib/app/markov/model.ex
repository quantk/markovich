defmodule App.Markov.Model do
  use Memoize

  def generate_model(history_path, model_path) do
    {:ok, content} = File.read(history_path)

    text =
      content
      |> String.downcase()
      |> String.split("\n")
      |> Enum.reverse()
      |> Enum.take(3000)
      |> Enum.join("\n")

    chain = Markovify.Text.model(text)
    {:ok, file} = File.open(model_path, [:write])
    IO.binwrite(file, :erlang.term_to_binary(chain))
    File.close(file)

    {:ok, file} = File.open(history_path, [:write])
    IO.binwrite(file, text)
    File.close(file)
  end

  defmemop load_model(model_path), expires_in: 60 * 1000 * 60 * 5 do
    {:ok, chain} = File.read(model_path)
    :erlang.binary_to_term(chain)
  end

  def generate_sentence(model_path) do
    chain = load_model(model_path)
    {_, result} = Markovify.Text.make_sentence(chain)
    {:ok, result}
  end
end
