defmodule KinoFly do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Fly Machines"
  alias KinoFly.Client

  @impl true
  def init(attrs, ctx) do
    fields = %{
      token: attrs["token"] || "",
      application: attrs["application"] || "",
      machine: attrs["machine"] || ""
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
    [token, application] = values
    result = Client.list_machines(token, application)
    IO.inspect(result, label: "RESULT")

    machines =
      case result do
        {:ok, machines} -> machines
        {:error, _} -> []
      end

    result =
      Enum.map(machines, fn x ->
        Client.get_machine_details(token, application, x)
      end)

    # IO.inspect(result, label: "RESULT")

    broadcast_event(ctx, "refresh", result)
    {:noreply, ctx}
  end

  def handle_event("deploy", values, ctx) do
    machines =
      Client.create_machine(values["token"], values["machine"], values["application"], [])

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
