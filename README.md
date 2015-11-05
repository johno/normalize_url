# NormalizeUrl [![Build Status](https://travis-ci.org/johnotander/normalize_url.svg?branch=master)](https://travis-ci.org/johnotander/normalize_url)

Normalize](https://en.wikipedia.org/wiki/URL_normalization) a url. This is useful for displaying, storing, sorting, etc.

## Usage

```elixir
NormalizeUrl.normalize("https://www.google.com?b=b&a=a") # => "https://google.com?a=a&b=b"
NormalizeUrl.normalize("//foo.bar#about") # => "http://foo.bar"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add normalize_url to your list of dependencies in `mix.exs`:

        def deps do
          [{:normalize_url, "~> 0.0.1"}]
        end

  2. Ensure normalize_url is started before your application:

        def application do
          [applications: [:normalize_url]]
        end

## Tests

```
mix test
```

## License

MIT

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Crafted with <3 by [John Otander](http://johnotander.com) ([@4lpine](https://twitter.com/4lpine)).
