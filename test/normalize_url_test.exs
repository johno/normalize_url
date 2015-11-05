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
end
