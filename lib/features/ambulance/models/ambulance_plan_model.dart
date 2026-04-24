class AmbulancePlanModel {
  final String id;
  final String title;
  final String price;
  final String description;
  final List<String> features;

  AmbulancePlanModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
  });
}

class AmbulancePlanService {
  static List<AmbulancePlanModel> getPlans() {
    return [
      AmbulancePlanModel(
        id: 'p1',
        title: 'Flat Standard Plan',
        price: '₹299/month',
        description: 'For individual flats requiring dedicated access.',
        features: [
          '24/7 Paramedic Response',
          'Free initial SOS ambulance dispatch',
          'Neighbor emergency alerts',
        ],
      ),
      AmbulancePlanModel(
        id: 'p2',
        title: 'Society Plan',
        price: '₹149/flat/month',
        description: 'Bulk subscription verified by RWA.',
        features: [
          '24/7 SOS capability',
          'Rapid driver assignment',
          'Society-wide alerts',
          'Discounted paramedic visits',
        ],
      )
    ];
  }
}
