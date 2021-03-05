//getRoutingData is now like the part of String class and now we can call it like below
//var routingData = settings.name.getRoutingData;

import 'package:jewtubefirestore/model/routingdata.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    Uri uriData = Uri.parse(this);

    print('uriData: ' + uriData.toString());

    return RoutingData(
        route: uriData.path, queryParameters: uriData.queryParameters);
  }
}
