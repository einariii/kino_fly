defmodule KinoFly do
  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Fly Machines"
  alias KinoFly.Client

  @interval_init 100
  @interval_refresh 3_000

  # https://livebook.dev/integrations/
  # Submit PR to ask to be added to integrations after cleanup

  # Add client code to be able to deploy to cities in a map
  # app = "mvkvc-protohackers"
  # cities = ["Boston", "Miami", "Tokyo"]
  # image = "flyio/fastify-functions"
  # Enum.map(cities, fn x -> KinoFly.deploy(app, image, x) end)
  # images = KinoFly.get_machines()
  # Enum.map(images, fn x -> KinoFly.delete_machine(app, ))
  # You get the idea
  # YOU CAN USE THE VALUES IN THE FORM SO MAKE IT COOL, CAN ONLY SPECIFY WHAT IS NEEDED

  @impl true
  def init(attrs, ctx) do
    fields = %{
      hostname: attrs["hostname"] || "https://api.machines.dev",
      token: attrs["token"] || System.get_env("FLY_TOKEN") || "",
      app: attrs["app"] || System.get_env("FLY_APP") || "",
      image: attrs["image"] || "",
      region: attrs["region"] || "",
      auto_refresh: attrs["auto_refresh"] || true
    }

    ctx = assign(ctx, fields: fields)
    Process.send(self(), "server_update", [])
    {:ok, ctx}
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
  def handle_info("server_update", ctx) do
    if ctx.assigns.fields.auto_refresh do
      Process.send(self(), "refresh", [])
    end

    Process.send_after(self(), "server_update", @interval_refresh)
    {:noreply, ctx}
  end

  @impl true
  def handle_info("refresh", ctx) do
    fields = ctx.assigns.fields
    result = Client.list_machines(fields.token, fields.app)

    data =
      case result do
        {:ok, machines} -> %{"machines" => machines}
        {:error, _} -> %{"machines" => []}
      end

    broadcast_event(ctx, "refresh", data)
    {:noreply, ctx}
  end

  def handle_event("toggle_auto_refresh", values, ctx) do
    fields = ctx.assigns.fields
    fields = Map.put(fields, :auto_refresh, values["auto_refresh"])
    {:noreply, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_event("update", values, ctx) do
    values =
      Enum.map(values, fn {k, v} ->
        if is_bitstring(k), do: {String.to_atom(k), v}, else: {k, v}
      end)

    values = Enum.into(values, %{})
    ctx = assign(ctx, fields: Map.merge(ctx.assigns.fields, values))
    {:noreply, ctx}
  end

  @impl true
  def handle_event("refresh", _values, ctx) do
    Process.send(self(), "refresh", [])
    {:noreply, ctx}
  end

  def handle_event("deploy", values, ctx) do
    fields = ctx.assigns.fields

    # Surface errors in UI later along with other commands
    Client.create_machine(fields.token, fields.app, fields.image, region: values["code"])

    {:noreply, ctx}
  end

  def handle_event("start", values, ctx) do
    fields = ctx.assigns.fields
    Client.start_machine(fields.token, values["machine"], fields.app)
    {:noreply, ctx}
  end

  def handle_event("stop", values, ctx) do
    fields = ctx.assigns.fields
    Client.stop_machine(fields.token, values["machine"], fields.app, region: fields.region)
    {:noreply, ctx}
  end

  def handle_event("delete", values, ctx) do
    fields = ctx.assigns.fields
    Client.delete_machine(fields.token, values["machine"], fields.app, force: true)
    {:noreply, ctx}
  end

  @impl true
  def to_source(_attrs) do
    quote do
      :ok
    end
    |> Kino.SmartCell.quoted_to_string()
  end
end
