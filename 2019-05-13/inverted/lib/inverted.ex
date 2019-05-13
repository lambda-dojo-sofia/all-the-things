defmodule Inverted do
  def load_comic_title (n) do
    {:ok, response} = SimpleHttp.get "https://xkcd.com/#{n}/info.0.json"
    %{"title" => title} = Jason.decode!(response.body)
    title
  end

  def hello do
    load_comic_title 2
  end
end
