defmodule TableParser do
  @moduledoc """
  Documentation for `TableParser`.
  """

  @doc """
  iex(1)> line = "root           1  0.0  0.0 184856  7180 ?        Ss   Dec16   0:29 /sbin/init" 
  iex(2)> TableParser.line_to_list(line)
  ["root", "1", "0.0", "0.0", "184856", "7180", "?", "Ss", "Dec16", "0:29",
   "/sbin/init"]
  iex(3)> line = "kuku     3844311  0.0  0.0   3896  1100 ?        Ss   17:41   0:00 /usr/bin/xsel --nodetach -i -b"
  iex(4)> TableParser.line_to_list(line, 11)
  ["kuku", "3844311", "0.0", "0.0", "3896", "1100", "?", "Ss", "17:41", "0:00", "/usr/bin/xsel --nodetach -i -b"]
  """
  def line_to_list(line, parts \\ :infinity) do
    line
    |> String.trim()
    |> String.split( ~r/\s+/, parts: parts)
  end

  @doc """
  iex(1)> header = "USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
  iex(2)> TableParser.get_columns_count(header)
  11
  """
  def get_columns_count(line) do
    line
    |> String.split()
    |> Enum.count()
  end

  @doc """
  iex(1)> header = "USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
  iex(2)> TableParser.get_keys_from_header(header)
  [:user, :pid, :"%cpu", :"%mem", :vsz, :rss, :tty, :stat, :start, :time, :command]

  """
  def get_keys_from_header(header) do
    header
    |> TableParser.line_to_list()
    |> Enum.map(fn key -> key |> String.downcase() |> String.to_atom() end)
  end

  @doc """
  Function gets a table separated by spaces and returns a list of maps with headers and values from the rows
  iex(1)> ps_output = \"\"\" 
  ...(1)> USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  ...(1)> root           1  0.0  0.0 184856  7180 ?        Ss   Dec16   0:29 /sbin/init
  ...(1)> \"\"\"
  iex(2)> TableParser.parse_table(ps_output)
  [
    %{
      "%cpu": 0.0,
      "%mem": 0.0,
      command: "/sbin/init",
      pid: 1.0,
      rss: 7180.0,
      start: "Dec16",
      stat: "Ss",
      time: "0:29",
      tty: "?",
      user: "root",
      vsz: 184856.0
    }
  ]

  """
  def parse_table(table) do
    [head | tail] =
      table
      |> String.trim()
      |> String.split("\n")

    keys = get_keys_from_header(head)
    lenght = get_columns_count(head)

    tail
    |> Enum.map(&line_to_list(&1, lenght))
    |> Enum.map(fn values ->
      Enum.zip(keys, values)
      |> Map.new()
    end)
  end
end
