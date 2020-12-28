defmodule TableParserTest do
  use ExUnit.Case
  doctest TableParser

  test "returns map of items using header as keys" do
    ps_output = """
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.0 184856  7180 ?        Ss   Dec16   0:29 /sbin/init
    root           2  0.0  0.0      0     0 ?        S    Dec16   0:00 [kthreadd]
    root           3  0.0  0.0      0     0 ?        I<   Dec16   0:00 [rcu_gp]
    root           4  0.0  0.0      0     0 ?        I<   Dec16   0:00 [rcu_par_gp]
    root           6  0.0  0.0      0     0 ?        I<   Dec16   0:00 [kworker/0:0H-kblockd]
    root           8  0.0  0.0      0     0 ?        I<   Dec16   0:00 [mm_percpu_wq]
    root           9  0.0  0.0      0     0 ?        S    Dec16   3:02 [ksoftirqd/0]
    root          10  0.0  0.0      0     0 ?        S    Dec16   0:00 [rcuc/0]
    root          11  0.0  0.0      0     0 ?        I    Dec16   5:37 [rcu_preempt]
    """

    assert TableParser.parse_table(ps_output) |> Enum.count() == 9

    assert TableParser.parse_table(ps_output) |> hd() == %{
             user: "root",
             pid: "1",
             "%cpu": "0.0",
             "%mem": "0.0",
             vsz: "184856",
             rss: "7180",
             tty: "?",
             stat: "Ss",
             start: "Dec16",
             time: "0:29",
             command: "/sbin/init"
           }
  end
end
