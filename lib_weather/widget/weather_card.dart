import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../weather_models/weather_model.dart';

class WeatherCard extends StatefulWidget {
  final Weather weather;
  final List<Forecast> forecast;

  const WeatherCard({super.key, required this.weather, required this.forecast});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with TickerProviderStateMixin {
  final int itemPerPage = 4;
  int currentPage = 0;

  late Timer _timer;
  late PageController _pageController;

  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  late AnimationController _scaleController;
  late Animation<double> _scaleBreath;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _startAutoScroll();

    // Fade + Scale Animation on card load
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    // Breathing scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleBreath = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        final nextPage =
            (currentPage + 1) % ((widget.forecast.length / itemPerPage).ceil());
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          currentPage = nextPage;
        });
      }
    });
  }

  String formateTime(int timestemp) {
    final date = DateTime.fromMicrosecondsSinceEpoch(timestemp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = (widget.forecast.length / itemPerPage).ceil();

    return ScaleTransition(
      scale: _fadeIn,
      child: FadeTransition(
        opacity: _fadeIn,
        child: ScaleTransition(
          scale: _scaleBreath,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  widget.weather.description.contains('rain')
                      ? 'assets/img/rain.json'
                      : widget.weather.description.contains('clear')
                      ? 'assets/img/cloudy.json'
                      : 'assets/img/sunny.json',
                  height: 150,
                  width: 150,
                ),
                Text(
                  widget.weather.cityName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: widget.weather.temperature),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => Text(
                    '${value.toStringAsFixed(1)}°C',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.weather.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Humidity: ${widget.weather.humidity}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Wind Speed: ${widget.weather.windspeed} m/s',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.orange,
                        ),
                        const Text('Sunrise'),
                        Text(formateTime(widget.weather.sunrise)),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(
                          Icons.nights_stay_outlined,
                          color: Colors.purple,
                        ),
                        const Text('Sunset'),
                        Text(formateTime(widget.weather.sunset)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  '5-Day Forecast',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 385,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pageCount,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (context, pageIndex) {
                      final start = pageIndex * itemPerPage;
                      final end = (start + itemPerPage).clamp(
                        0,
                        widget.forecast.length,
                      );
                      final items = widget.forecast.sublist(start, end);
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final f = items[index];
                          final dateTime = DateFormat(
                            'EEE, hh a',
                          ).format(DateTime.parse(f.date));
                          return TweenAnimationBuilder<Offset>(
                            tween: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ),
                            duration: Duration(
                              milliseconds: 400 + (index * 100),
                            ),
                            builder: (context, offset, child) =>
                                Transform.translate(
                                  offset: Offset(offset.dx * 100, 0),
                                  child: Card(
                                    margin: const EdgeInsets.all(8),
                                    color: Colors.white30,
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            dateTime,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Image.network(
                                            'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                                            width: 50,
                                            height: 50,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.cloud),
                                          ),
                                          Text(
                                            '${f.temp.toStringAsFixed(0)}°C',
                                          ),
                                          Text(
                                            f.description,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pageCount, (index) {
                    final isSelected = index == currentPage;
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 12,
                        ),
                        width: isSelected ? 12 : 8,
                        height: isSelected ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.blueAccent : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
