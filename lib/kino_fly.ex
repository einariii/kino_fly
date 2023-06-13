defmodule KinoFly do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Fly Machines"
  # alias KinoFly.Client

  @impl true
  def init(_attrs, ctx) do
    {:ok, %{}, ctx}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{}, ctx}
  end

  @impl true
  def to_attrs(_ctx) do
    %{}
  end

  @impl true
  def to_source(_attrs) do
    quote do
      IO.puts("No source code for this cell.")
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
