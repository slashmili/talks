## Fibo live demo
```bash
$ mix new fibo

mix new fibo
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/fibo.ex
* creating test
* creating test/test_helper.exs
* creating test/fibo_test.exs

Your mix project was created successfully.
You can use mix to compile it, test it, and more:

    cd fibo
    mix test

Run `mix help` for more commands.
$ cd fibo
$ mix test
.

Finished in 0.09 seconds (0.09s on load, 0.00s on tests)
1 tests, 0 failures

Randomized with seed 810692
```

Edit test/fibo_test.exs
```elixir
defmodule FiboTest do
  use ExUnit.Case

  test "fib for 0 should be 1" do
    assert Fibo.fib(0) == 1
  end
end
```

And the test should fail!

```bash
$ mix test


  1) test fib for 0 should be 1 (FiboTest)
     test/fibo_test.exs:4
     ** (UndefinedFunctionError) undefined function: Fibo.fib/1
     stacktrace:
       (fibo) Fibo.fib(0)
       test/fibo_test.exs:5



Finished in 0.09 seconds (0.08s on load, 0.01s on tests)
1 tests, 1 failures

Randomized with seed 898601
```

Edit lib/fibo.ex
```elixir
defmodule Fibo do
  def fib(0) do
    1
  end
end
```

Run the test
```bash
$ mix test
.

Finished in 0.1 seconds (0.1s on load, 0.00s on tests)
1 tests, 0 failures

Randomized with seed 261777
```
**Hooray**!!! It even works

Let's continue by writing another failing test. Edit test/fibo_test.exs
```elixir
defmodule FiboTest do
  use ExUnit.Case

  test "fib for 0 should be 1" do
    assert Fibo.fib(0) == 1
  end

  test "fib for 1 should be 1" do
    assert Fibo.fib(1) == 1
  end
end
```
I hope test will fail! Let's see
```bash
mix test


  1) test fib for 1 should be 1 (FiboTest)
     test/fibo_test.exs:8
     ** (FunctionClauseError) no function clause matching in Fibo.fib/1
     stacktrace:
       (fibo) lib/fibo.ex:2: Fibo.fib(1)
       test/fibo_test.exs:9

.

Finished in 0.1 seconds (0.09s on load, 0.02s on tests)
2 tests, 1 failures

Randomized with seed 15376
```
And the implementation should be simple
```elixir
defmodule Fibo do
  def fib(0) do
    1
  end

  def fib(1) do
    1
  end
end
```
And check the test
```bash
$ mix test
Compiled lib/fibo.ex
Generated fibo app
..

Finished in 0.09 seconds (0.09s on load, 0.00s on tests)
2 tests, 0 failures

Randomized with seed 754752
```

Yup, works


Let's fast forward to fib of 5


Edit the test file
```elixir
defmodule FiboTest do
  use ExUnit.Case

  test "fib for 0 should be 1" do
    assert Fibo.fib(0) == 1
  end

  test "fib for 1 should be 1" do
    assert Fibo.fib(1) == 1
  end

  test "fib for 5 should be 8" do
    assert Fibo.fib(5) == 8
  end
end
```
Run the test
```bash
$ mix test
Compiled lib/fibo.ex
Generated fibo app


  1) test fib for 5 should be 8 (FiboTest)
     test/fibo_test.exs:12
     ** (FunctionClauseError) no function clause matching in Fibo.fib/1
     stacktrace:
       (fibo) lib/fibo.ex:2: Fibo.fib(5)
       test/fibo_test.exs:13

..

Finished in 0.1 seconds (0.1s on load, 0.02s on tests)
3 tests, 1 failures

Randomized with seed 859839
```

And the code should be like this
```elixir
defmodule Fibo do
  def fib(0) do
    1
  end

  def fib(1) do
    1
  end

  def fib(n) do
    fib(n-2) + fib(n-1)
  end
end
```
And the test should pass
```bash
$ mix test
Compiled lib/fibo.ex
Generated fibo app
...

Finished in 0.1 seconds (0.1s on load, 0.00s on tests)
3 tests, 0 failures

Randomized with seed 391180
```
We can refactor the fib function to make it more like an elixir code!
```elixir
defmodule Fibo do
  def fib(n) when n < 2 do
    1
  end

  def fib(n) do
    fib(n-2) + fib(n-1)
  end
end
```
The _when_ keyword is called [guard clauses](http://elixir-lang.org/crash-course.html#identifying-functions)

Let's confirm it's working
```bash
$ mix test
Compiled lib/fibo.ex
Generated fibo app
...

Finished in 0.1 seconds (0.1s on load, 0.00s on tests)
3 tests, 0 failures

Randomized with seed 715322
```
