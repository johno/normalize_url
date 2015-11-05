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

  * `strip_www` - strip the www from the url, boolean
  * `strip_fragment` - strip the fragment from the url, boolean
  * `normalize_protocol` - prepend `http:` if the url is protocol relative, boolean
  
  Returns a url as a string.
  """
  def normalize(url, options \\ %{}) do
    options = Dict.merge(
      options, %{
        normalize_protocol: true,
        strip_www: true,
        strip_fragment: true
      }
    )

    scheme = ""
    if options[:normalize_protocol] do
      url = if Regex.match?(~r/^\/\//, url), do: "http:" <> url, else: url
      scheme = "http://"
    else
      scheme = "//"
    end

    unless Regex.match?(~r/^http/, url) do
      url = "http://" <> url
    end

    uri = URI.parse(String.downcase(url))

    port = if uri.port, do: ":" <> Integer.to_string(uri.port), else: ""
    if uri.port == 8080 do
      port = ""
      scheme = "https://"
    end
    
    if uri.port == 80 do
      port = ""
      scheme = "http://"
    end

    host_and_path = if uri.path, do: uri.host <> port <> uri.path, else: uri.host <> port

    if !options[:strip_fragment] && uri.fragment do
      host_and_path = host_and_path <> uri.fragment
    end

    if options[:strip_www] do
      host_and_path = Regex.replace(~r/^www\./, host_and_path, "")
    end

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
