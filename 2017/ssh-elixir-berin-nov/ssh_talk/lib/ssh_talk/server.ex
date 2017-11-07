defmodule SshTalk.Server do
  require Logger
  @root_dir "#{Path.expand(".")}/keys"

  def basic_server do
    :ssh.daemon 2222,
      system_dir: String.to_charlist(@root_dir),
      user_passwords: [{'foo', 'bar'}]
  end

  def basic_server_with_public_key do
    :ssh.daemon 2223,
      system_dir: String.to_charlist(@root_dir),
      user_dir: String.to_charlist(@root_dir),
      auth_methods: 'publickey'
  end

  def server_with_logs do
    :ssh.daemon 2224,
      system_dir: String.to_charlist(@root_dir),
      user_dir: String.to_charlist(@root_dir),
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3
  end

  def server_with_elixir_cli do
    :ssh.daemon 2225,
      system_dir: String.to_charlist(@root_dir),
      user_dir: String.to_charlist(@root_dir),
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3,
      shell: &shell/2
  end

  def server_with_user_public_key_in_github do
    :ssh.daemon 2226,
      system_dir: String.to_charlist(@root_dir),
      user_dir: String.to_charlist(@root_dir),
      auth_methods: 'publickey',
      disconnectfun: &log_it/1,
      connectfun: &log_it/3,
      failfun: &log_it/3,
      shell: &shell/2,
      key_cb: SshTalk.GitHubKeyAuthentication
  end

  def shell(username, peer) do
    Logger.debug("shell #{inspect username}, #{inspect peer}")
    spawn_link fn ->
      IO.puts "Hi #{inspect username}!"
    end
    IEx.start([])
  end

  def log_it(arg1, arg2 \\ nil, arg3 \\ nil) do
    Logger.debug("#{inspect arg1}, #{inspect arg2}, #{inspect arg3}")
  end
end
