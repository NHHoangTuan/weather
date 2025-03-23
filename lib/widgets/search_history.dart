import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final history = weatherProvider.searchHistory;

        if (history.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No search history'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Search History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final location = history.keys.elementAt(index);
                  final data = history[location];
                  final weather = data['weather'];
                  final searchTime = DateTime.parse(data['searchTime']);

                  return ListTile(
                    leading: Image.network(
                      weather['iconUrl'],
                      width: 40,
                      height: 40,
                    ),
                    title: Text(location),
                    subtitle: Text(
                      'Temp: ${weather['temperature']}°C - ${weather['condition']}',
                    ),
                    trailing: Text(
                      _formatDateTime(searchTime),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      weatherProvider.fetchWeather(location);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute}';
  }
}
