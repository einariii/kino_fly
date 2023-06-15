defmodule KinoFly.Client do
  # https://fly.io/docs/machines/working-with-machines/

  def create_app(token, org, app, opts \\ []) do
    # curl -i -X POST \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps" \
    # -d '{
    #   "app_name": "user-functions",
    #   "org_slug": "personal"
    # }'

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    body =
      Jason.encode!(%{
        app_name: app,
        org_slug: org
      })

    Req.post("#{hostname}/v1/apps", body: body, headers: headers)
  end

  def get_app_details(token, app, opts \\ []) do
    # curl -i -X GET \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    Req.get("#{hostname}/v1/apps/#{app}", headers: headers)
  end

  def create_machine(token, app, name, image, opts \\ []) do
    # curl -i -X POST \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines" \
    # -d '{
    #   "name": "quirky-machine",
    #   "config": {
    #     "image": "flyio/fastify-functions",
    #     "env": {
    #       "APP_ENV": "production"
    #     },
    #     "services": [
    #       {
    #         "ports": [
    #           {
    #             "port": 443,
    #             "handlers": [
    #               "tls",
    #               "http"
    #             ]
    #           },
    #           {
    #             "port": 80,
    #             "handlers": [
    #               "http"
    #             ]
    #           }
    #         ],
    #         "protocol": "tcp",
    #         "internal_port": 8080
    #       }
    #     ],
    #     "checks": {
    #         "httpget": {
    #             "type": "http",
    #             "port": 8080,
    #             "method": "GET",
    #             "path": "/",
    #             "interval": "15s",
    #             "timeout": "10s"
    #         }
    #     }
    #   }
    # }'

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    body =
      Jason.encode!(%{
        name: name,
        config: %{
          image: image
        }
      })

    Req.post("#{hostname}/v1/apps/#{app}/machines", body: body, headers: headers)
  end

  def get_machine_details(token, app, machine, opts \\ []) do
    # curl -i -X GET \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines/73d8d46dbee589"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    Req.get("#{hostname}/v1/apps/#{app}/machines/#{machine}", headers: headers)
  end

  def update_machine() do
    # Not supported yet
  end

  def stop_machine(token, machine, app, opts \\ []) do
    # curl -i -X POST \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines/73d8d46dbee589/stop"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    Req.post("#{hostname}/v1/apps/#{app}/machines/#{machine}/stop", headers: headers)
  end

  def start_machine(token, machine, app, opts \\ []) do
    # curl -i -X POST \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines/73d8d46dbee589/start"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    Req.post("#{hostname}/v1/apps/#{app}/machines/#{machine}/start", headers: headers)
  end

  def delete_machine(token, app, machine, opts \\ []) do
    # curl -i -X DELETE \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines/24d896dec64879"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    Req.delete("#{hostname}/v1/apps/#{app}/machines/#{machine}", headers: headers)
  end

  def list_machines(token, app, opts \\ []) do
    # curl -i -X GET \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    {:ok, response} = Req.get("#{hostname}/v1/apps/#{app}/machines", headers: headers)

    response
    |> parse_response()

    # |> IO.inspect(label: "list_machines")
  end

  def delete_application() do
    # Not supported yet
  end

  def lease_machine() do
    # Not supported yet
  end

  defp parse_response(%Req.Response{status: 200, body: [body]}) do
    IO.puts("Parsed successful response")
    IO.inspect(body, label: "BODY")
    x = {:ok, [body["id"]]}
    x |> IO.inspect(label: "X")
    x
  end

  defp parse_response(%Req.Response{}) do
    IO.puts("Parsed error response")
    {:error, :invalid_response}
  end
end

# Failed to serialize widget data, value {:ok, %{__struct__: Req.Response, body: %{"error" => "invalid authentication"}, headers: [{"content-type", "application/json; charset=utf-8"}, {"fly-trace-id", "9b9300e831a213b147063a5de1a8ea4e"}, {"date", "Thu, 15 Jun 2023 03:33:40 GMT"}, {"content-encoding", "gzip"}, {"x-envoy-upstream-service-time", "35"}, {"server", "Fly/a0b91024 (2023-06-13)"}, {"transfer-encoding", "chunked"}, {"via", "1.1 fly.io"}, {"fly-request-id", "01H2YHVCY4WC2VSDJYN64PNWRS-yyz"}], private: %{}, status: 401}} is not JSON-serializable, use another data type
