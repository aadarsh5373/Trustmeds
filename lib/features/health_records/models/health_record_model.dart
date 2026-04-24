class HealthRecordModel {
  final String id;
  final String title;
  final String type; // prescription, report, vaccination, allergy
  final String fileUrl;
  final DateTime date;
  final String doctorName;
  final String notes;

  HealthRecordModel({
    required this.id,
    required this.title,
    required this.type,
    this.fileUrl = '',
    required this.date,
    this.doctorName = '',
    this.notes = '',
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json, String id) {
    return HealthRecordModel(
      id: id,
      title: json['title'] ?? '',
      type: json['type'] ?? 'report',
      fileUrl: json['fileUrl'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      doctorName: json['doctorName'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
        'fileUrl': fileUrl,
        'date': date.toIso8601String(),
        'doctorName': doctorName,
        'notes': notes,
      };

  String get typeLabel {
    switch (type) {
      case 'prescription':
        return 'Prescription';
      case 'report':
        return 'Lab Report';
      case 'vaccination':
        return 'Vaccination';
      case 'allergy':
        return 'Allergy';
      default:
        return 'Record';
    }
  }
}
