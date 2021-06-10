defmodule App.Markov.Model do
  use Memoize

  def generate_model(history_path, model_path) do
    {:ok, content} = File.read(history_path)
    text = content |> String.downcase()

    {:ok, chain} = Faust.generate_chain(text, 2)
    {:ok, file} = File.open(model_path, [:write])
    IO.binwrite(file, :erlang.term_to_binary(chain))
    File.close(file)
  end

  defmemop load_model(model_path), expires_in: 60 * 1000 * 60 * 5 do
    {:ok, chain} = File.read(model_path)
    :erlang.binary_to_term(chain)
  end

  def generate_sentence(model_path, message \\ nil) do
    chain = load_model(model_path)

    case message do
      nil ->
        {:ok, _result} = App.Markov.MyFaust.traverse(chain, Enum.random(2..15), &random/1)

      text ->
        {:ok, result} = App.Markov.MyFaust.traverse(chain, Enum.random(2..15), &random/1, text)

        if result === message do
          {:error, :not_found}
        else
          {:ok, result}
        end
    end
  end

  defp random(edges) do
    edges =
      Enum.sort(edges, fn {_, koef1}, {_, koef2} ->
        koef1 > koef2
      end)

    edges = Enum.take(edges, 5)
    {edge, _} = Enum.random(edges)
    edge
  end
end
