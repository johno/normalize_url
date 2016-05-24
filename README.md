# normalize_url [![Build Status](https://travis-ci.org/johnotander/normalize_url.svg?branch=master)](https://travis-ci.org/johnotander/normalize_url)

[Normalize](https://en.wikipedia.org/wiki/URL_normalization) a url. This is useful for displaying, storing, sorting, etc.

## Installation

Add :normalize_url to your list of dependencies in `mix.exs`

```elixir
def deps do
  [{:normalize_url, "~> 0.0.2"}]
end
```

Ensure :normalize_url is started before your application

```elixir
def application do
  [applications: [:normalize_url]]
end
```

## Usage

```elixir
NormalizeUrl.normalize_url("https://www.google.com?b=b&a=a")
# => "https://google.com?a=a&b=b"

NormalizeUrl.normalize_url("//foo.bar#about")
# => "http://foo.bar"
```

#### Options

##### strip_www

Type: `boolean`   
Default: `true`

Remove `www.` from the url

```elixir
NormalizeUrl.normalize_url("http://www.johnotander.com")
# => "http://johnotander.com"

NormalizeUrl.normalize_url("http://www.johnotander.com", [strip_www: false])
# => "http://www.johnotander.com"
```

##### strip_fragment

Type: `boolean`   
Default: `true`

Remove `#framents` from the url

```elixir
NormalizeUrl.normalize_url("http://johnotander.com#about.html")
# => "http://johnotander.com"

NormalizeUrl.normalize_url("http://www.johnotander.com", [strip_fragment: false])
# => "http://johnotander.com#about.html"
```

##### :normalize_protocol

Type: `boolean`   
Default: `true`

Normalize relative protocols

```elixir
NormalizeUrl.normalize_url("//johnotander.com#about")
# => "http://johnotander.com"

NormalizeUrl.normalize_url("//www.johnotander.com", [normalize_protocol: false])
# => "//johnotander.com"
```

##### add_root_path

Type: `boolean`   
Default: `false`

Adds a trailing slash for the root path, if the path is empty.

```elixir
NormalizeUrl.normalize_url("http://example.com")
# => "http://example.com"

NormalizeUrl.normalize_url("http://example.com", [add_root_path: true])
# => "http://example.com/"
```

## Development

```
mix test
```

## Related

* Elixir port from the [`normalize-url`](https://github.com/sindresorhus/normalize-url) node module by [Sindre Sorhus](https://github.com/sindresorhus).

## License

MIT

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Crafted with <3 by [John Otander](http://johnotander.com) ([@4lpine](https://twitter.com/4lpine)).
