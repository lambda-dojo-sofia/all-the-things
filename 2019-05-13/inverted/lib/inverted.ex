defmodule Inverted do
  def next_comic do
    "https://xkcd.com/2/info.0.json"
  end

  def hello do
    {:ok, response} = SimpleHttp.get Inverted.next_comic
    %{"title" => title} = Jason.decode!(response.body)
    title
  end
end
