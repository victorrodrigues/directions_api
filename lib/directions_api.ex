require IEx;

defmodule DirectionsApi do
	use HTTPoison.Base

	alias DirectionsApi.JSON

	@type response :: nil | {integer, any} | Poison.Parser.t

  @spec process_response(HTTPoison.Response.t) :: response
  def process_response(%HTTPoison.Response{status_code: 200, body: ""}), do: nil
  def process_response(%HTTPoison.Response{status_code: 200, body: body}), do: JSON.decode!(body)
  def process_response(%HTTPoison.Response{status_code: status_code, body: ""}), do: { status_code, nil }
  def process_response(%HTTPoison.Response{status_code: status_code, body: body }), do: { status_code, JSON.decode!(body) }

	def _request(method, url, body \\ "") do
    json_request(method, url, body)
  end

	def json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    request!(method, url, JSON.encode!(body), headers, options) |> process_response
  end

	def result(org, des, opts \\ %{}) do
  	format_url(org, des, opts)
    	|> fetch
    	|> JSON.decode!
    	|> DirectionsApi.Parser.parse
  end

	defp format_url(origin, destination, opts) do
		default_params(origin, destination)
		|> prepare_waypoints(opts)
		|> prepare_units(opts)
		|> prepare_mode(opts)
		|> prepare_avoid(opts)
		|> prepare_language(opts)
		|> prepare_region(opts)
		|> prepare_arrival_time(opts)
		|> prepare_departure_time(opts)
		|> prepare_url
	end

	defp default_params(origin, destination, opts \\ %{}) do
		%{origin: origin, destination: destination, key: key}
	end

	defp prepare_url(url) do
		URI.encode_query(url)
		|> endpoint
	end

	def prepare_waypoints(default_opts, opts) do
		if Map.has_key?(opts, :waypoints) do
			waypoints =
				cond do
					is_list(opts[:waypoints]) -> Enum.join(opts[:waypoints], "|")
					is_nil(opts[:waypoints]) -> []
					true -> opts[:waypoints]
				end
			Map.merge(%{ opts | waypoints: waypoints }, default_opts)
		else
			default_opts
		end
	end

	defp prepare_units(default_opts, opts) do
		if Map.has_key?(opts, :units) do
			Map.merge(opts, default_opts)
		else
			default_opts
		end
	end

	defp prepare_mode(default_opts, opts) do
		if Map.has_key?(opts, :mode) do
			Map.merge(opts, default_opts)
		else
			default_opts
		end
	end

	defp prepare_avoid(default_opts, opts) do
		if Map.has_key?(opts, :avoid) do
			avoid =
				cond do
					is_list(opts[:avoid]) -> Enum.join(opts[:avoid], "|")
					is_nil(opts[:avoid]) -> []
					true -> opts[:avoid]
				end
			Map.merge(%{ opts | avoid: avoid }, default_opts)
		else
			default_opts
		end
	end

	defp prepare_language(default_opts, opts) do
		if Map.has_key?(opts, :language) do
			Map.merge(opts, default_opts)
		else
			default_opts
		end
	end

	defp prepare_region(default_opts, opts) do
		if Map.has_key?(opts, :region) do
			Map.merge(opts, default_opts)
		else
			default_opts
		end
	end

	defp prepare_arrival_time(default_opts, opts) do
		if Map.has_key?(opts, :arrival_time) do
			Map.merge(opts, default_opts)
		else
			default_opts
		end
	end

	defp prepare_departure_time(default_opts, opts) do
		if Map.has_key?(opts, :departure_time) do
			Map.merge(opts, default_opts)
		else
			default_opts
		end
	end

	defp endpoint(url) do
		"https://maps.googleapis.com/maps/api/directions/json?" <> url
	end

	defp key do
		Application.get_env(:directions_api, :api_key)
	end

	defp fetch(url) do
		char_list_url = to_char_list(url)
		{ :ok, {{_version, 200, _reason_phrase}, _headers, body } } = :httpc.request(char_list_url)
    body
	end

end
