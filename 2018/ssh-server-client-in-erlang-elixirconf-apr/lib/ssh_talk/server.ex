defmodule SshTalk.Server do
  require Logger
  @sys_dir String.to_charlist("#{Path.expand(".")}/sys_dir")

  def basic_server do
    :ssh.daemon(
      2222,
      system_dir: @sys_dir,
      user_passwords: [{'foo', 'bar'}]
    )
  end

  @usr_dir String.to_charlist("#{Path.expand(".")}/usr_dir")

  def basic_server_with_public_key do
    :ssh.daemon(
      2222,
      system_dir: @sys_dir,
      user_dir: @usr_dir,
      auth_methods: 'publickey'
    )
  end

  def server_with_logs do
    :ssh.daemon(
      2222,
      system_dir: @sys_dir,
      user_dir: @usr_dir,
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3
    )
  end

  def log_it(a1, a2 \\ nil, a3 \\ nil) do
    require Logger
    Logger.debug("#{inspect(a1)}, #{inspect(a2)}, #{inspect(a3)}")
  end

  def server_with_elixir_cli do
    :ssh.daemon(
      2222,
      system_dir: @sys_dir,
      user_dir: @usr_dir,
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3,
      shell: &shell/2
    )
  end

  def shell(username, peer) do
    require Logger
    require IEx
    Logger.debug("shell #{inspect(username)}, #{inspect(peer)}")
    IEx.start([])
  end

  def server_with_users_github_public_key do
    {:ok, _} =
      Registry.start_link(
        keys: :duplicate,
        name: Registry.PubSubTest,
        partitions: System.schedulers_online()
      )

    :ssh.daemon(
      2222,
      system_dir: @sys_dir,
      user_dir: @usr_dir,
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3,
      # shell: &shell/2,
      shell: &echo_shell/2,
      key_cb: SshTalk.GitHubKeyAuthentication
    )
  end

  def server_with_custom_subsystem do
    :ssh.daemon(
      2222,
      system_dir: @sys_dir,
      user_dir: @usr_dir,
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3,
      shell: &shell/2,
      key_cb: SshTalk.GitHubKeyAuthentication,
      subsystems: [{'echo', {SshTalk.EchoSubsystem, []}}]
    )
  end

  defp echo_shell(username, peer) do
    username = to_string(username)
    Logger.debug("echo shell #{inspect(username)}, #{inspect(peer)}")

    dispatch(String.trim("#{username} has joined"))

    receive_pid =
      spawn_link(fn ->
        {:ok, _} = Registry.register(Registry.PubSubTest, "hello", [self()])
        outout_loop(username)
      end)

    loop = fn ->
      send(receive_pid, {:input, self(), IO.gets(:stdio, "#{username}-> ")})
    end

    spawn_link(fn ->
      IO.puts("ECHO SSH shell - presse Ctr+C to quit")

      1..1
      |> Stream.cycle()
      |> Enum.any?(fn _ -> loop.() == :exit end)
    end)
  end

  def dispatch(message) do
    Registry.dispatch(Registry.PubSubTest, "hello", fn entries ->
      for {pid, [other_pid]} when pid != self() <- entries, do: send(pid, {:broadcast, message})
    end)
  end

  def outout_loop(username) do
    receive do
      {:input, _, "exit\n"} ->
        IO.puts("Exiting...")
        :exit

      {:input, _, {:error, _}} ->
        outout_loop(username)

      {:input, _, message} ->
        Logger.warn("#{inspect(message)}")

        dispatch("#{username}: #{String.trim(to_string(message))}")
        outout_loop(username)

      {:broadcast, any} ->
        # throw(:boo)
        Logger.warn("#{inspect(any)} <-?")
        IO.puts(any)
        outout_loop(username)
    end
  end
end
