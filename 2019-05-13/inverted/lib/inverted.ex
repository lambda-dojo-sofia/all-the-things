defmodule Inverted do
  def next_comic do
    "https://xkcd.com/2/info.0.json"
  end

  def hello do
    {:ok, response} = SimpleHttp.get Inverted.next_comic
    json_response = Jason.decode!(~s(response.body))
    json_response
  end
end
