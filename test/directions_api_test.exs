defmodule DirectionsApiTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc
  doctest DirectionsApi

  setup do
    Application.put_env(:directions_api, :api_key, "")
  end

  test "return not found" do
    expected = %DirectionsApi.Record.Default{} = DirectionsApi.result("cant reach", "why?")
    assert expected.status == "NOT_FOUND"
  end

  test "get geocoded waypoints" do
    expected_result = [
      %DirectionsApi.Record.GeocodedWaypoints{
        geocoder_status: "OK",
        place_id: "ChIJw9B9ksY_zpQRz1aWD1UNzc0",
        types: ["locality", "political"]
      },
      %DirectionsApi.Record.GeocodedWaypoints{
        geocoder_status: "OK",
        place_id: "ChIJ0WGkg4FEzpQRrlsz_whLqZs",
        types: ["locality", "political"]
      }
    ]

    result  = DirectionsApi.result("São Bernardo do Campo, SP", "São Paulo, SP")

    assert expected_result == result.geocoded_waypoints
  end

  test "get routes and return the legs with distance and duration" do

    expected_result = %DirectionsApi.Record.Legs{
      distance: %{text: "26.2 km", value: 26165 },
      duration: %{text: "36 mins", value: 2179 }
    }

    result = DirectionsApi.result("São Bernardo do Campo, SP", "São Paulo, SP").routes

    assert expected_result.distance == List.first(List.first(result).legs).distance
    assert expected_result.duration == List.first(List.first(result).legs).duration

  end

  test "directions with one waypoint" do

    expected_result = [
      %DirectionsApi.Record.Legs{
        distance: %{text: "9.7 km", value: 9662 },
        duration: %{text: "22 mins", value: 1340   }
      },
      %DirectionsApi.Record.Legs{
        distance: %{text: "21.8 km", value: 21790 },
        duration: %{text: "34 mins", value: 2014 }
      }
    ]

    result = DirectionsApi.result("São Bernardo do Campo, SP", "São Paulo, SP", %{ waypoints: "Diadema, SP" })

    legs = List.first(result.routes).legs

    assert Enum.count(legs) == 2
    assert List.first(expected_result).distance == List.first(legs).distance
    assert List.first(expected_result).duration == List.first(legs).duration

  end

  test "directions with more than one waypoint" do

    expected_result = [
      %DirectionsApi.Record.Legs{
        distance: %{text: "57.1 km", value: 57128 },
        duration: %{text: "1 hour 6 mins", value: 3949  }
      },
      %DirectionsApi.Record.Legs{
        distance: %{text: "21.8 km", value: 21790 },
        duration: %{text: "34 mins", value: 2014 }
      }
    ]

    result = DirectionsApi.result("Adelaide,SA", "Adelaide,SA", %{ waypoints: ["Barossa Valley,SA" , "Clare,SA", "Connawarra,SA", "McLaren Vale,SA"] })

    legs = List.first(result.routes).legs

    assert Enum.count(legs) == 5
    assert List.first(expected_result).distance == List.first(legs).distance
    assert List.first(expected_result).duration == List.first(legs).duration

  end

  test "directions with imperial unit" do

    expected_result = %DirectionsApi.Record.Legs{
      distance: %{text: "16.3 mi", value: 26165 },
      duration: %{text: "36 mins", value: 2179 }
    }

    result = DirectionsApi.result("São Bernardo do Campo, SP", "São Paulo, SP", %{ units: "imperial" }).routes

    assert expected_result.distance == List.first(List.first(result).legs).distance
    assert expected_result.duration == List.first(List.first(result).legs).duration

  end

  test "distance & time: error when req denied" do
    Application.put_env(:directions_api, :api_key, "Wrong key")
    assert DirectionsApi.result("Vancouver", "San Francisco") == {:error, "The provided API key is invalid."}
  end

end
