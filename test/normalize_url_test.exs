defmodule NormalizeUrlTest do
  use ExUnit.Case
  doctest NormalizeUrl

  test "adds a protocol" do
    assert(NormalizeUrl.normalize_url("google.com") == "http://google.com")
  end

  test "keeps the http protocol" do
    assert(NormalizeUrl.normalize_url("http://google.com") == "http://google.com")
  end

  test "keeps the https protocol" do
    assert(NormalizeUrl.normalize_url("https://google.com") == "https://google.com")
  end

  test "handles ftp protocols" do
    assert(NormalizeUrl.normalize_url("ftp://google.com") == "ftp://google.com")
  end

  test "handles ftp protocols with fragments" do
    assert(NormalizeUrl.normalize_url("ftp://google.com#blah") == "ftp://google.com")
  end

  test "handles a url that starts with ftp" do
    assert(NormalizeUrl.normalize_url("ftp.com") == "http://ftp.com")
  end

  test "strips a relative protocol and replaces with http" do
    assert(NormalizeUrl.normalize_url("//google.com") == "http://google.com")
  end

  test "adds the correct protocol if 8080 is specified" do
    assert(NormalizeUrl.normalize_url("//google.com:8080") == "https://google.com")
  end

  test "adds the correct protocol if 80 is specified" do
    assert(NormalizeUrl.normalize_url("//google.com:80") == "http://google.com")
  end

  test "sorts query params" do
    assert(NormalizeUrl.normalize_url("google.com?b=foo&a=bar&123=hi") == "http://google.com?123=hi&a=bar&b=foo")
  end

  test "strips url fragment" do
    assert(NormalizeUrl.normalize_url("johnotander.com#about") == "http://johnotander.com")
  end

  test "strips www" do
    assert(NormalizeUrl.normalize_url("www.johnotander.com") == "http://johnotander.com")
  end

  test "does not strip a relative protocol with option normalize_protocol: false" do
    assert(NormalizeUrl.normalize_url("//google.com", [normalize_protocol: false]) == "//google.com")
  end

  test "does not strip www with option strip_www: false" do
    assert(NormalizeUrl.normalize_url("www.google.com", [strip_www: false]) == "http://www.google.com")
  end

  test "does not strip a url fragment with option strip_fragment: false" do
    assert(NormalizeUrl.normalize_url("www.google.com#about.html", [strip_fragment: false]) == "http://google.com#about.html")
  end
end
