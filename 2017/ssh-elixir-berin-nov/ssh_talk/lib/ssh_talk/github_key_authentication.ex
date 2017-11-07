defmodule SshTalk.GitHubKeyAuthentication do
  @behaviour :ssh_server_key_api

  require Logger

  def host_key(algorithm, daemon_options) do
    :ssh_file.host_key(algorithm, daemon_options)
  end

  def is_auth_key({:RSAPublicKey, _, _} = key, username, daemon_options) do
    is_auth_key({key, []}, username, daemon_options)
  end

  def is_auth_key(key, username, _daemon_options) do
    key_str =
      [key]
      |> :public_key.ssh_encode(:auth_keys)
      |> String.trim
    key_str in fetch_github_user_pub_keys(username)
  end

  def fetch_github_user_pub_keys(username) do
    username = to_string(username)
    with {:ok, response} <- HTTPoison.get("https://api.github.com/users/#{username}/keys"),
         {:ok, body} <- Poison.decode(response.body) do
      Enum.map(body, &Map.get(&1, "key"))
    else
      reason ->
        Logger.error("failed to fetch user's keys, error: #{inspect reason}")
      []
    end
  end
end
