defmodule Rumbl.UserSocket do
  use Phoenix.Socket
  alias Phoenix.Token
  @max_age 2 * 7 * 24 * 60 * 60
  ## Channels
  channel "videos:*", Rumbl.VideoChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  def id(socket) do
    "users_socket:#{socket.assigns.user_id}"
  end

  def id(_socket), do: nil
end
