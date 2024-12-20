defmodule ElixirMobileWeb.SlideLive do
  use ElixirMobileWeb, :live_view

  @max_page 4

  @impl true
  def mount(_args, _session, socket) do
    socket
    |> assign(page: 0)
    |> then(&{:ok, &1})
  end

  @impl true
  def handle_event("next", %{}, socket) do
    page =
      if socket.assigns.page == @max_page do
        0
      else
        socket.assigns.page + 1
      end

    socket
    |> assign(page: page)
    |> then(&{:noreply, &1})
  end

  @impl true
  def handle_event("prev", %{}, socket) do
    page =
      if socket.assigns.page == 0 do
        @max_page
      else
        socket.assigns.page - 1
      end

    socket
    |> assign(page: page)
    |> then(&{:noreply, &1})
  end
end
