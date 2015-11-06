defmodule NormalizeUrlTest do
  use ExUnit.Case
  doctest NormalizeUrl

  test "adds a protocol" do
    assert(NormalizeUrl.normalize("google.com") == "http://google.com")
  end

  test "strips a relative protocol and replaces with http" do
    assert(NormalizeUrl.normalize("//google.com") == "http://google.com")
  end

  test "adds the correct protocol if 8080 is specified" do
    assert(NormalizeUrl.normalize("//google.com:8080") == "https://google.com")
  end

  test "adds the correct protocol if 80 is specified" do
    assert(NormalizeUrl.normalize("//google.com:80") == "http://google.com")
  end

  test "sorts query params" do
    assert(NormalizeUrl.normalize("google.com?b=foo&a=bar&123=hi") == "http://google.com?123=hi&a=bar&b=foo")
  end

  test "strips url fragment" do
    assert(NormalizeUrl.normalize("johnotander.com#about") == "http://johnotander.com")
  end

  test "strips www" do
    assert(NormalizeUrl.normalize("www.johnotander.com") == "http://johnotander.com")
  end

  test "does not strip a relative protocol with option normalize_protocol: false" do
    assert(NormalizeUrl.normalize("//google.com", [normalize_protocol: false]) == "//google.com")
  end

  test "does not strip www with option strip_www: false" do
    assert(NormalizeUrl.normalize("www.google.com", [strip_www: false]) == "http://www.google.com")
  end

  test "does not strip a url fragment with option strip_fragment: false" do
    assert(NormalizeUrl.normalize("www.google.com#about.html", [strip_fragment: false]) == "http://google.com#about.html")
  end
end
