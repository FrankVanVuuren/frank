defmodule Frank.ParserTest do
  use ExUnit.Case

  describe "parsing atoms" do
    test "parse mutliple atoms" do
      ["foo", 666.0, "\"hail satan\"", 6.66] = Frank.Parser.parse(~s[foo 666 "hail satan" 6.66])
    end

    test "parse a symbol" do
      ["foo"] = Frank.Parser.parse(~s[foo])
    end

    test "parse multiple symbols" do
      ["foo", "bar", "baz"] = Frank.Parser.parse(~s[foo bar baz])
    end

    test "parse a number; integer" do
      [666.0] = Frank.Parser.parse(~s[666])
      [-666.0] = Frank.Parser.parse(~s[-666])
    end

    test "parse a number; float" do
      [6.66] = Frank.Parser.parse(~s[6.66])
      [-6.66] = Frank.Parser.parse(~s[-6.66])
    end

    test "parse a string; simple" do
      ["\"satan\""] = Frank.Parser.parse(~s["satan"])
    end

    test "parse a string; multiple words do" do
      [
        "\"hail lord satan! Drink the blood of \"The Nazarene\"!\""
      ] = Frank.Parser.parse(~s["hail lord satan! Drink the blood of \"The Nazarene\"!"])
    end

    test "parse strings; multiple" do
      ["\"satan\"", "\"lucifer\"", "\"antichrist\""] =
        Frank.Parser.parse(~s["satan" "lucifer" "antichrist"])
    end
  end

  describe "parsing lists" do
    test "parse a list" do
      [["foo", "bar", "baz"]] = Frank.Parser.parse(~s[(foo bar baz)])
    end

    test "parse a nested list" do
      expected = [["define", "add2", ["lambda", ["x"], ["+", "x", 2.0]]]]
      result = Frank.Parser.parse(~s[(define add2 (lambda (x) (+ x 2)))])

      ^expected = result
    end
  end
end
