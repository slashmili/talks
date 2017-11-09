defmodule SshTalk.Client do
  require Logger

  def simple_client(host, port \\ 22, username \\ nil) do
    username = if username == nil do
      to_charlist(System.get_env("USER"))
    else
      to_charlist(username)
    end
    :ssh.connect String.to_charlist(host), port,
      disconnectfun: &log_it/1,
      user: username
  end

  def client_with_public_key(host, port \\ 22, username \\ nil) do
    username = if username == nil do
      to_charlist(System.get_env("USER"))
    else
      to_charlist(username)
    end

    :ssh.connect String.to_charlist(host), port,
      disconnectfun: &log_it/1,
      unexpectedfun: &log_it/2,
      user_dir: to_charlist(Path.join([System.get_env("HOME"), ".ssh"])),
      auth_methods: 'publickey',
      user: username
      #rsa_pass_phrase: 'if you have passphrase'
  end

  def client_with_custom_subsystem(hostname, username) do
    {:ok, conn_ref} = client_with_public_key(hostname, 2227, username)
    {:ok, chan} = :ssh_connection.session_channel(conn_ref, :infinity)
    :success = :ssh_connection.subsystem(conn_ref, chan, 'echo', :infinity)
    :ssh_connection.send(conn_ref, chan, "helloo", :infinity)
  end

  def log_it(arg1, arg2 \\ nil) do
    Logger.debug("#{inspect arg1}, #{inspect arg2}")
    :report
  end
end
