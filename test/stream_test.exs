defmodule StreamTest do
  use ExUnit.Case

  import Xlsxir

  def path(), do: "./test/test_data/test.xlsx"

  test "produces a stream" do
    s = stream_list(path(), 8)
    assert %Stream{} = s
    assert 51 == s |> Enum.map(&(&1)) |> length
  end

  test "stream can run multiple times" do
    s = stream_list(path(), 8)
    assert %Stream{} = s
    # First run should proceed normally
    assert {:ok, _} = Task.yield( Task.async( fn() -> s |> Stream.run() end ), 2000)
    # second run will hang on missing fs resources (before fix) and hang (default 60s)
    assert {:ok, _} = Task.yield( Task.async( fn() -> s |> Stream.run() end ), 2000)
    # third run because reasons
  end

  test "empty cells are filled with nil" do
    s = stream_list(path(), 9)

    assert s |> Enum.map(& &1) == [
             [1, nil, 1, nil, 1, nil, nil, 1],
             [nil, 1, nil, nil, 1, nil, 1],
             [nil, nil, nil, nil, nil, 1, nil, nil, nil, 1],
             [1, 1, nil, 1]
           ]
  end
end
