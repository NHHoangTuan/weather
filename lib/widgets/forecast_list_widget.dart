import 'package:flutter/material.dart';
import '../models/forecast.dart';

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;
  final VoidCallback onLoadMore;

  const ForecastList({
    Key? key,
    required this.forecasts,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine grid size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final crossAxisCount = screenWidth > 1100
        ? 4
        : screenWidth > 700
            ? 3
            : 2;

    final itemHeight =
        (MediaQuery.of(context).size.width / crossAxisCount) / 0.7;
    final rowCount = (forecasts.length + 1 + crossAxisCount - 1) ~/
        crossAxisCount; // +1 cho nút Load More, làm tròn lên
    final gridHeight =
        rowCount * itemHeight + (rowCount - 1) * 12; // 12 là mainAxisSpacing

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Forecast Grid
        isDesktop
            ? Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount:
                      forecasts.length + 1, // +1 for the load more button
                  itemBuilder: (context, index) {
                    // Show load more button at the end
                    if (index == forecasts.length) {
                      return _buildLoadMoreCard();
                    }

                    // Show forecast card
                    final forecast = forecasts[index];
                    return _buildForecastCard(
                      forecast.date,
                      forecast.iconUrl,
                      forecast.avgTempC,
                      forecast.maxWindKph,
                      forecast.avgHumidity,
                      forecast.condition.text,
                    );
                  },
                ),
              )
            : SizedBox(
                height: gridHeight,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount:
                      forecasts.length + 1, // +1 for the load more button
                  itemBuilder: (context, index) {
                    // Show load more button at the end
                    if (index == forecasts.length) {
                      return _buildLoadMoreCard();
                    }

                    // Show forecast card
                    final forecast = forecasts[index];
                    return _buildForecastCard(
                      forecast.date,
                      forecast.iconUrl,
                      forecast.avgTempC,
                      forecast.maxWindKph,
                      forecast.avgHumidity,
                      forecast.condition.text,
                    );
                  },
                ),
              )
      ],
    );
  }

  // Load more button card
  Widget _buildLoadMoreCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
      ),
      child: Center(
        child: InkWell(
          onTap: onLoadMore,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 48,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 12),
              Text(
                'Load More',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForecastCard(
    String date,
    String icon,
    double temp,
    double wind,
    int humidity,
    String condition,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Image.network(
            icon.replaceFirst("file://", "https://"),
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.cloud,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            condition,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            '${temp.toStringAsFixed(1)}°C',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wind: ${wind.toStringAsFixed(1)} km/h',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Humidity: $humidity%',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
