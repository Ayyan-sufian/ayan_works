import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/view_model_weather.dart';
import '../weather_models/animations.dart';
import '../widget/weather_card.dart';

class MyAppHome extends StatefulWidget {
  const MyAppHome({super.key});

  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> with TickerProviderStateMixin {
  final List<String> citySuggestions = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Multan',
    'Faisalabad',
  ];

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) =>
              Opacity(opacity: value, child: child),
          child: const Text("Weather App"),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient:
              vm.weather != null &&
                  vm.weather!.description.toLowerCase().contains("rain")
              ? const LinearGradient(
                  colors: [Colors.grey, Colors.blueGrey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : vm.weather != null &&
                    vm.weather!.description.toLowerCase().contains('clear')
              ? const LinearGradient(
                  colors: [Colors.orangeAccent, Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [Colors.grey, Colors.lightBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children: [
              ScaleTransition(
                scale: _logoAnimation,
                child: Container(
                  height: 120,
                  child: Image.asset("assets/img/weather-icon.webp"),
                ),
              ),
              const SizedBox(height: 20),
              const AnimatedText(
                text: "Weather App",
                style: TextStyle(fontSize: 26, color: Colors.white),
                delay: Duration(milliseconds: 500),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RawAutocomplete<String>(
                  textEditingController: vm.cityNameController,
                  focusNode: FocusNode(),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return citySuggestions.where((String city) {
                      return city.toLowerCase().startsWith(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                try {
                                  await vm.getWeather();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            label: const AnimatedText(
                              text: "City",
                              style: TextStyle(color: Colors.white),
                              delay: Duration(milliseconds: 700),
                            ),
                            hintText: 'Enter your city',
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Material(
                      color: Colors.white,
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await vm.getWeatherByLocation();
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const AnimatedText(
                  text: "Get current Weather",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    backgroundColor: Colors.transparent,
                  ),
                  delay: Duration(milliseconds: 1000),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              if (vm.isLoading)
                const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (vm.weather != null && vm.forecast != null)
                SizedBox(
                  width: double.infinity,
                  child: WeatherCard(
                    weather: vm.weather!,
                    forecast: vm.forecast!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
