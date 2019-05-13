defmodule Inverted do

  def load_comic_title (n) do
    {:ok, response} = SimpleHttp.get "https://xkcd.com/#{n}/info.0.json"
    if response.status == 200 do
      %{"title" => title} = Jason.decode!(response.body)
      title
    end
  end

  def collect_all_titles(titles, current_title) do
    if current_title > 25 do
      titles
    else
      n = load_comic_title current_title
      [n | (collect_all_titles titles, current_title + 1)]
    end
  end

  def hello do
    titles = collect_all_titles [], 1
    dict_words = Enum.map(titles, fn t -> String.split(t, " ") end)
    Enum.reduce(
      dict_words,
      %{},
      fn (words, acc) ->

      end)
    dict
  end
end
