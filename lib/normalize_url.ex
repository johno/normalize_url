defmodule NormalizeUrl do
  @moduledoc """
  The base module of NormalizeUrl.

  It exposes a single function, normalize_url.
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
  def normalize_url(url, options \\ []) do
    options = Keyword.merge([
      normalize_protocol: true,
      strip_www: true,
      strip_fragment: true,
      add_root_path: false
    ], options)

    scheme = ""
    url = if Regex.match?(~r/^\/\//, url), do: "http:" <> url, else: url
    if options[:normalize_protocol] do
      scheme = if Regex.match?(~r/^ftp:\/\//, url), do: "ftp://", else: "http:"
    else
      scheme = "//"
    end

    if options[:normalize_protocol] && !Regex.match?(~r/^(http|ftp:\/\/)/, url) do
      url = "http://" <> url
    end

    uri = URI.parse(String.downcase(url))

    port = if options[:normalize_protocol] && uri.port, do: ":" <> Integer.to_string(uri.port), else: ""
    if uri.port == 8080 || uri.port == 443 do
      port = ""
      scheme = "https://"
    end

    if uri.port == 21 && scheme == "ftp://" do
      port = ""
    end

    if options[:normalize_protocol] && uri.port == 80 do
      port = ""
      scheme = "http://"
    end

    path = uri.path
    if options[:add_root_path] && is_nil(path) do
      path = "/"
    end

    host_and_path = if path, do: uri.host <> port <> path, else: uri.host <> port

    if !options[:strip_fragment] && uri.fragment do
      host_and_path = host_and_path <> "#" <> uri.fragment
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
