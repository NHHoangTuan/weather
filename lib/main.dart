import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:weather/providers/subscription_provider.dart';
import 'package:weather/providers/weather_provider.dart';
import 'package:weather/screens/email_verification_screen.dart';
import 'package:weather/screens/subscription_screen.dart';
import 'package:weather/screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          // Parse route URI for verification
          if (settings.name?.startsWith('/verify') ?? false) {
            final uri = Uri.parse(settings.name!);
            final email = uri.queryParameters['email'];
            final token = uri.queryParameters['token'];

            if (email != null && token != null) {
              return MaterialPageRoute(
                builder: (_) => EmailVerificationScreen(
                  email: email,
                  token: token,
                ),
              );
            }
          }

          return null;
        },
        routes: {
          '/': (context) => const WeatherScreen(),
          '/subscribe': (context) => const SubscriptionScreen(),
        },
      ),
    );
  }
}
