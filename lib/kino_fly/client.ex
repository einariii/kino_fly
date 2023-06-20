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

  def create_machine(token, app, image, opts \\ []) do
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

    region = Keyword.get(opts, :region, nil)
    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    config = %{
      image: image
    }

    body =
      if region do
        %{region: region, config: config}
      else
        %{config: config}
      end

    body = Jason.encode!(body)
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

    {:ok, response} = Req.get("#{hostname}/v1/apps/#{app}/machines/#{machine}", headers: headers)

    # id = response.body["id"]
    name = response.body["name"]
    image = response.body["config"]["image"]
    region = response.body["region"]

    %{id: machine, name: name, image: image, region: region}
  end

  defp update_machine() do
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

  def delete_machine(token, machine, app, opts \\ []) do
    force = Keyword.get(opts, :force, false)
    # curl -i -X DELETE \
    # -H "Authorization: Bearer ${FLY_API_TOKEN}" -H "Content-Type: application/json" \
    # "${FLY_API_HOSTNAME}/v1/apps/user-functions/machines/24d896dec64879"

    hostname = Keyword.get(opts, :hostname, "https://api.machines.dev")

    headers = %{
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }

    uri =
      "#{hostname}/v1/apps/#{app}/machines/#{machine}" <> if force, do: "?force=true", else: ""

    Req.delete(uri, headers: headers)
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

    case response do
      %Req.Response{status: 200, body: body} ->
        info =
          cond do
            is_list(body) ->
              Enum.map(body, fn y ->
                refresh_extract_fields(y)
              end)

            true ->
              refresh_extract_fields(body)
          end

        {:ok, info}

      _ ->
        {:error, :invalid_response}
    end
  end

  defp delete_application() do
    # Not supported yet
  end

  defp lease_machine() do
    # Not supported yet
  end

  defp refresh_extract_fields(attrs) do
    %{
      "id" => attrs["id"],
      "name" => attrs["name"],
      "image" => attrs["config"]["image"],
      "region" => attrs["region"],
      "state" => attrs["state"]
    }
  end
end
