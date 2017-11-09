defmodule SshTalk.EchoSubsystem do
  @behaviour :ssh_daemon_channel
  require Logger

  def init(opt) do
    {:ok, opt}
  end

  def handle_msg({:ssh_channel_up, _channel_id, _connection_manager}, state) do
    {:ok, state}
  end

  def handle_ssh_msg({:ssh_cm, cm, {:data, channel_id, 0, data}}, state) do
    Logger.debug "handle_ssh_msg(#{inspect {:ssh_cm, cm, {:data, channel_id, 0, data}}})"
    :ssh_connection.send(cm, channel_id, data)
    {:ok, state}
  end

  def handle_ssh_msg({:ssh_cm, cm, {:data, channel_id, 1, data}}, state) do
    Logger.debug "handle_ssh_msg(#{inspect {:ssh_cm, cm, {:data, channel_id, 1, data}}})"
    {:ok, state}
  end

  def handle_ssh_msg({:ssh_cm, cm, {:eof, channel_id}}, state) do
    Logger.debug "handle_ssh_msg(#{inspect {:ssh_cm, cm, {:eof, channel_id}}})"
    {:ok, state}
  end

  def handle_ssh_msg({:ssh_cm, cm, {:signal, channel_id}}, state) do
    Logger.debug "handle_ssh_msg(#{inspect {:ssh_cm, cm, {:signal, channel_id}}})"
    #Ignore signals according to RFC 4254 section 6.9.
    {:ok, state}
  end

  def handle_ssh_msg({:ssh_cm, cm, {:exit_signal, channel_id, error}}, state) do
    Logger.debug "handle_ssh_msg(#{inspect {:ssh_cm, cm, {:exit_signal, channel_id, error}}})"
    {:stop, channel_id,  state};
  end

  def handle_ssh_msg({:ssh_cm, cm, {:exit_status, channel_id, status}}, state) do
    Logger.debug "handle_ssh_msg(#{inspect {:ssh_cm, cm, {:exit_status, channel_id, status}}})"
    {:stop, channel_id,  state};
  end

  def terminate(_reason, _state) do
    :ok
  end
end
