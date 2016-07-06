defmodule DirectionsApi.Parser do
	@moduledoc """
  Parse Google Directions API results into custom types.
  """

	@doc """
  Parse record from the API response json.
  """
	@spec parse(Map.t) :: DirectionsApi.Record.Default.t
	def parse(%{error_message: error, status: "REQUEST_DENIED"}), do: {:error, error}
	def parse(%{error_message: error, status: "NOT_FOUND"}), do: {:error, error}
	def parse(o) do
		r = struct(DirectionsApi.Record.Default, o)
		%{ r | 	geocoded_waypoints: parse_geocoded_waypoints(r.geocoded_waypoints),
						routes: parse_routes(r.routes)
		 }
	end

	@doc """
  Parse geocoded_waypoints record from the API response json.
  """
	@spec parse_geocoded_waypoints(Map.t) :: DirectionsApi.Record.GeocodedWaypoints.t
	def parse_geocoded_waypoints(waypoints) do
		waypoints |> Enum.map(&DirectionsApi.Parser.parse_geocoded_waypoint/1)
	end

	@spec parse_geocoded_waypoint(Map.t) :: DirectionsApi.Record.GeocodedWaypoints.t
	def parse_geocoded_waypoint(waypoint) do
		struct(DirectionsApi.Record.GeocodedWaypoints, waypoint)
	end

	@doc """
  Parse routes record from the API response json.
  """
	@spec parse_routes([Map.t] | nil) :: [DirectionsApi.Record.Routes.t] | nil
	def parse_routes(nil), do: nil
	def parse_routes(object) do
		object |> Enum.map(&DirectionsApi.Parser.parse_route/1)
	end

	@doc """
  Parse route record from the API response json.
  """
	@spec parse_route(Map.t) :: DirectionsApi.Record.Routes.t
	def parse_route(object) do
		route = struct(DirectionsApi.Record.Routes, object)

		%{ route | 	legs: parse_legs(route.legs) }
	end

	@doc """
  Parse legs record from the API response json.
  """
	@spec parse_legs([Map.t] | nil) :: [DirectionsApi.Record.Legs.t] | nil
	def parse_legs(nil), do: nil
	def parse_legs(object) do

		object |> Enum.map(&DirectionsApi.Parser.parse_leg/1)
	end

	@doc """
  Parse leg record from the API response json.
  """
	@spec parse_leg(Map.t) :: DirectionsApi.Record.Legs
	def parse_leg(object) do
		leg = struct(DirectionsApi.Record.Legs, object)
		%{ leg | steps: parse_steps(leg.steps) }
	end

	@doc """
  Parse steps record from the API response json.
  """
	@spec parse_steps([Map.t] | nil) :: [DirectionsApi.Record.Steps.t] | nil
	def parse_steps(object) do
		object |> Enum.map(&DirectionsApi.Parser.parse_step/1)
	end

	@doc """
  Parse step record from the API response json.
  """
	@spec parse_step(Map.t) :: DirectionsApi.Record.Steps.t
	def parse_step(step) do
		struct(DirectionsApi.Record.Steps, step)
	end

end
