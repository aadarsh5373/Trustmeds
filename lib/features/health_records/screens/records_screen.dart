import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../services/mock_data_service.dart';
import '../models/health_record_model.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = MockDataService.getHealthRecords();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Health Records'),
          backgroundColor: AppColors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_rounded, color: AppColors.primary),
              onPressed: () => Get.toNamed('/add-record'),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700),
            unselectedLabelStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Prescriptions'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecordsList(records),
            _buildRecordsList(records.where((r) => r.type == 'prescription').toList()),
            _buildRecordsList(records.where((r) => r.type == 'report' || r.type == 'vaccination').toList()),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed('/add-record'),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text('Add Record',
              style: GoogleFonts.nunito(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _buildRecordsList(List<HealthRecordModel> records) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softPink.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.folder_open_rounded,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text('No records found',
                style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final record = records[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blushPink.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(record.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getTypeIcon(record.type),
                    color: _getTypeColor(record.type), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.title,
                        style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTypeColor(record.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(record.typeLabel,
                              style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getTypeColor(record.type))),
                        ),
                        const SizedBox(width: 8),
                        Text(Formatters.date(record.date),
                            style: GoogleFonts.nunito(
                                fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                    if (record.doctorName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(record.doctorName,
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
            ],
          ),
        );
      },
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'prescription': return Icons.description_rounded;
      case 'report': return Icons.analytics_rounded;
      case 'vaccination': return Icons.vaccines_rounded;
      case 'allergy': return Icons.warning_rounded;
      default: return Icons.folder_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'prescription': return AppColors.primary;
      case 'report': return AppColors.info;
      case 'vaccination': return AppColors.success;
      case 'allergy': return AppColors.warning;
      default: return AppColors.textMuted;
    }
  }
}
