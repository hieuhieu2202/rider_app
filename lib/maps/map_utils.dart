import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static void launchMapFromSourceToDestination(double sourceLat, double sourceLng, double destinationLat, double destinationLng) async {
    String mapOption = [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate',
    ].join('&');

    final Uri mapUrl = Uri.parse('http://www.google.com/maps?$mapOption');

    if (await canLaunch(mapUrl.toString())) {
      await launch(mapUrl.toString());
    } else {
      throw "Could not launch $mapUrl";
    }
  }
}
