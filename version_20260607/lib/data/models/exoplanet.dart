class Exoplanet {
  final String name;
  final double? mass;
  final double? radius;
  final double? distance;
  final double? temperature;

  Exoplanet({
    required this.name,
    this.mass,
    this.radius,
    this.distance,
    this.temperature,
  });

  factory Exoplanet.fromJson(Map<String, dynamic> json) {
    return Exoplanet(
      name: json['pl_name'] ?? 'Unknown',
      mass: json['pl_bmasse']?.toDouble(),
      radius: json['pl_rade']?.toDouble(),
      distance: json['sy_dist']?.toDouble(),
      temperature: json['pl_eqt']?.toDouble(),
    );
  }
}
