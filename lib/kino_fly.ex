defmodule KinoFly do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Fly Machines"
  alias KinoFly.Client

  @impl true
  def init(attrs, ctx) do
    fields = %{
      hostname: attrs["hostname"] || "https://api.machines.dev",
      token: attrs["token"] || System.get_env("FLY_TOKEN") || "",
      app: attrs["app"] || "",
      image: attrs["image"] || "",
      machines: attrs["machines"] || ""
    }

    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, %{fields: ctx.assigns.fields}, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    ctx.assigns.fields
  end

  @impl true
  def handle_event("refresh", values, ctx) do
    IO.inspect(values, label: "VALUESAESUAS")
    [token, app] = values
    result = Client.list_machines(token, app)
    IO.inspect(result, label: "RESULT")

    data =
      case result do
        {:ok, info} -> %{"info" => info, "status" => "ok"}
        {:error, _} -> %{"info" => [], "status" => "error"}
      end

    broadcast_event(ctx, "refresh", data)
    {:noreply, ctx}
  end

  def handle_event("deploy", values, ctx) do
    machines = Client.create_machine(values["token"], values["app"], values["image"], [])

    broadcast_event(ctx, "deploy", %{machines: machines})
    {:noreply, ctx}
  end

  @impl true
  def to_source(_attrs) do
    quote do
      IO.puts("No source code for this cell.")
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
