class RoutingData {
  final String route;
  final Map<String, Object> _queryParameters;
  RoutingData({
    this.route,
    Map<String, Object> queryParameters,
  }) : _queryParameters = queryParameters;
  operator [](String key) => _queryParameters[key];
}