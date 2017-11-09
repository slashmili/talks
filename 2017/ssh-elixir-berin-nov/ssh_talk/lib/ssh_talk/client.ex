defmodule SshTalk.Client do
  require Logger

  def simple_client(host, port \\ 22) do
    :ssh.connect String.to_charlist(host), port,
      disconnectfun: &log_it/1
  end

  def client_with_public_key(host, port \\ 22) do
    :ssh.connect String.to_charlist(host), port,
      disconnectfun: &log_it/1,
      unexpectedfun: &log_it/2,
      user_dir: to_charlist(Path.join([System.get_env("HOME"), ".ssh"])),
      auth_methods: 'publickey'
      #user: 'optional',
      #rsa_pass_phrase: 'optional'
  end

  def log_it(arg1, arg2 \\ nil) do
    Logger.debug("#{inspect arg1}, #{inspect arg2}")
    :report
  end
end
