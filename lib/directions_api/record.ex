defmodule DirectionsApi.Record.Default do
	defstruct [
		:geocoded_waypoints,
		:routes,
		:status
	]

	@type t :: %DirectionsApi.Record.Default{
		geocoded_waypoints: [DirectionsApi.Record.GeocodedWaypoints.t],
		routes: 						[DirectionsApi.Record.Routes.t],
		status: 						binary
	}

end

defmodule DirectionsApi.Record.GeocodedWaypoints do
	defstruct [ :geocoder_status, :place_id, :partial_match, :types ]

	@type t :: %DirectionsApi.Record.GeocodedWaypoints{
		geocoder_status: 	binary,
		place_id: 				binary,
		types: 						[binary],
		partial_match:		boolean
	}
end

defmodule DirectionsApi.Record.Routes do
	defstruct [ :bounds, :copyrights, :legs, :overview_polyline, :sumary,
							:warnings, :waypoint_order]

	@type t :: %DirectionsApi.Record.Routes{
		bounds: 						DirectionsApi.Record.Bounds.t,
		copyrights: 				binary,
		legs: 							[DirectionsApi.Record.Legs.t],
		overview_polyline: 	DirectionsApi.Record.OverviewPolyline.t,
		sumary: 						binary,
		warnings: 					[binary],
		waypoint_order: 		[pos_integer],
		# fare:								DirectionsApi.Record.Fare.t
	}
end

defmodule DirectionsApi.Record.Fare do
	defstruct [:currency, :value, :text]

	@type t :: %DirectionsApi.Record.Fare{
		currency: binary,
		value: 		float,
		text: 		binary
	}
end

defmodule DirectionsApi.Record.Bounds do
	defstruct [:northeast, :southwest]

	@type t :: %DirectionsApi.Record.Bounds{
		northeast: DirectionsApi.Record.LatLng.t,
		southwest: DirectionsApi.Record.LatLng.t
	}
end

defmodule DirectionsApi.Record.LatLng do
	defstruct [:lat, :lng]
	@type t :: %DirectionsApi.Record.LatLng{
		lat: float,
		lng: float
	}
end

defmodule DirectionsApi.Record.Legs do
	defstruct [
			:distance, :duration, :end_address, :end_location,
			:start_address, :start_location, :steps, :traffic_speed_entry,
			:via_waypoint
		]
	@type t :: %DirectionsApi.Record.Legs{
		distance: 						DirectionsApi.Record.Distance.t,
		duration: 						DirectionsApi.Record.Duration.t,
		end_address: 					binary,
		end_location: 				DirectionsApi.Record.LatLng.t,
		start_address: 				binary,
		start_location: 			DirectionsApi.Record.LatLng.t,
		steps: 								[DirectionsApi.Record.Steps.t],
		traffic_speed_entry: 	nil,
		via_waypoint: 				nil
	}
end

defmodule DirectionsApi.Record.Distance do
	defstruct [:text, :value]
	@type t :: %DirectionsApi.Record.Distance{
		text: 	binary,
		value: 	binary
	}
end

defmodule DirectionsApi.Record.Duration do
	defstruct [:text, :value]
	@type t :: %DirectionsApi.Record.Duration{
		text: 	binary,
		value: 	binary
	}
end

defmodule DirectionsApi.Record.Steps do
	defstruct [
		:distance, :duration, :end_location, :html_instructions, :polyline,
		:start_location, :travel_mode
	]
	@type t :: %DirectionsApi.Record.Steps{
		distance: 					DirectionsApi.Record.Distance.t,
		duration: 					DirectionsApi.Record.Duration.t,
		end_location: 			DirectionsApi.Record.LatLng.t,
		html_instructions: 	binary,
		polyline: 					DirectionsApi.Record.Polyline.t,
		start_location: 		DirectionsApi.Record.LatLng.t,
		travel_mode:				binary
	}
end

defmodule DirectionsApi.Record.Polyline do
	defstruct [:points]
	@type t :: %DirectionsApi.Record.Polyline{ points: binary }
end
