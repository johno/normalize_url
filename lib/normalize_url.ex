defmodule NormalizeUrl do
  @moduledoc """
  The base module of NormalizeUrl.

  It exposes a single method, normalize.
  """

  @doc """
  Normalizes a url. This is useful for displaying, storing, comparing, etc.

  Args:

  * `url` - the url to normalize, string

  Options:

  * `stripWWW` - strip the www from the url, boolean
  * `stripFragment` - strip the fragment from the url, boolean
  * `normalizeProtocol` - prepend `http:` if the url is protocol relative, boolean
  
  Returns a url as a string.
  """
  def normalize(url, options \\ []) do
    url = if Regex.match?(~r/^\/\//, url), do: "http:" <> url, else: url
    url = if Regex.match?(~r/^http/, url), do: url, else: "http://" <> url
    uri = URI.parse(String.downcase(url))

#    IO.puts inspect(uri)

    scheme = if uri.port == 8080, do: "https://", else: "http://"
    host_and_path = if uri.path, do: uri.host <> uri.path, else: uri.host

    host_and_path = Regex.replace(~r/^www\./, host_and_path, "")

    query_params = ""
    if uri.query do
      query_params_dict = URI.decode_query(uri.query)
      sorted_query_params = Enum.map(query_params_dict, fn{k, v} -> "#{k}=#{v}" end)
                            |> Enum.join("&")
      query_params = "?" <> sorted_query_params
    end

    scheme <> host_and_path <> query_params
  end
end
