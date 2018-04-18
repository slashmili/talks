defmodule SshTalk.Client do
  def simple_client(host, port \\ 22) do
    :ssh.connect(
      String.to_charlist(host),
      port,
      disconnectfun: &log_it/1
    )
  end

  def client_with_public_key(host, port, username) do
    :ssh.connect(
      String.to_charlist(host),
      port,
      disconnectfun: &log_it/1,
      unexpectedfun: &log_it/2,
      user_dir: String.to_charlist(Path.join([System.get_env("HOME"), ".ssh"])),
      auth_methods: 'publickey',
      user: String.to_charlist(username)
      # rsa_pass_phrase: 'optional'
      # ecdsa_pass_phrase: 'optional'
    )
  end

  def client_with_custom_subsystem(hostname, port, username) do
    {:ok, conn_ref} = client_with_public_key(hostname, port, username)
    {:ok, chan} = :ssh_connection.session_channel(conn_ref, :infinity)
    :success = :ssh_connection.subsystem(conn_ref, chan, 'echo', :infinity)
    :ssh_connection.send(conn_ref, chan, "Is there anybody out there?", :infinity)
  end

  def log_it(a1, a2 \\ nil, a3 \\ nil) do
    require Logger
    Logger.debug("#{inspect(a1)}, #{inspect(a2)}, #{inspect(a3)}")
  end
end
