import 'package:health/health.dart';
import 'foot_steps.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthRepository {
  final HealthFactory health = HealthFactory();

  Future<List<FootSteps>> getFootSteps() async {
    // Check and request activity recognition permission
    if (!await _requestActivityRecognitionPermission()) {
      print("Activity recognition permission not granted.");
      return [];
    }

    // Try to request authorization and fetch health data
    try {
      bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

      if (requested) {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now(),
          [HealthDataType.STEPS],
        );

        // Map the health data to FootSteps
        return healthData.map((dataPoint) {
          return FootSteps(
            double.parse(dataPoint.value.toString()),
            dataPoint.unitString,
            dataPoint.dateFrom,
            dataPoint.dateTo,
          );
        }).toList();
      } else {
        print("Authorization not granted.");
      }
    } catch (e) {
      print("Error fetching health data: $e");
    }

    return [];
  }

  // Request activity recognition permission
  Future<bool> _requestActivityRecognitionPermission() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      // Request the permission
      status = await Permission.activityRecognition.request();
    }
    return status.isGranted;
  }
}
