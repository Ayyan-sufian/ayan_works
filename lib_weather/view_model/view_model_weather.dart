import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/Notification.dart';
import '../services/service_dart.dart';
import '../weather_models/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController cityNameController = TextEditingController();

  bool isLoading = false;
  Weather? weather;
  List<Forecast>? forecast;

  Future<void> getWeather() async {
    _setLoading(true);
    try {
      final w = await _weatherServices.fetchWeather(cityNameController.text);
      final f = await _weatherServices.fetchForecast(cityNameController.text);
      weather = w;
      forecast = f;

      _checkWeatherAlerts();
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getWeatherByLocation() async {
    _setLoading(true);
    try {
      final position = await _determinePosition();
      final w = await _weatherServices.fetchWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      final f = await _weatherServices.fetchForecastByLocation(
        position.latitude,
        position.longitude,
      );
      weather = w;
      forecast = f;

      _checkWeatherAlerts();
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location service is disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission is denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _checkWeatherAlerts() {
    if (weather == null) return;

    final temp = weather!.temperature;
    final condition = weather!.description.toLowerCase();

    // if (condition.contains('rain')) {
    //   NotificationService.showAlert(
    //     "Rain Alert",
    //     "Rain expected today in ${weather!.cityName}",
    //   );
    // } else if (temp > 38) {
    //   NotificationService.showAlert(
    //     "Heat Alert",
    //     "High temperature: $temp°C in ${weather!.cityName}",
    //   );
    // } else if (temp < 10) {
    //   NotificationService.showAlert(
    //     "Cold Alert",
    //     "Low temperature: $temp°C in ${weather!.cityName}",
    //   );
    // }
  }
}
