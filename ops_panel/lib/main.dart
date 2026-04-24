import 'package:flutter/material.dart';

void main() {
  runApp(const TrustMedsOpsApp());
}

class TrustMedsOpsApp extends StatelessWidget {
  const TrustMedsOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrustMeds Ops',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D6A5F),
          primary: const Color(0xFF2D6A5F),
          secondary: const Color(0xFFB9846A),
          surface: const Color(0xFFFFFCF8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F1EA),
      ),
      home: const OpsDashboardScreen(),
    );
  }
}

class OpsDashboardScreen extends StatelessWidget {
  const OpsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summaryCards = const [
      _MetricData('Orders Today', '268', Icons.receipt_long_rounded),
      _MetricData('Revenue Today', '₹1.84L', Icons.payments_rounded),
      _MetricData('Delivered', '214', Icons.local_shipping_rounded),
      _MetricData('Pending', '54', Icons.schedule_rounded),
    ];

    final orderRows = const [
      _OrderRow('TM24042001', 'Riya Sharma', 'UPI', 'Verified', '11 min ago'),
      _OrderRow(
          'TM24042002', 'Aman Verma', 'Cash', 'Out for Delivery', '27 min ago'),
      _OrderRow('TM24042003', 'Niharika Jain', 'UPI', 'Packed', '42 min ago'),
    ];

    final deliveryRows = const [
      _DeliveryRow('Rahul', '18 orders', '22 min avg', '₹3,420 COD'),
      _DeliveryRow('Sandeep', '15 orders', '25 min avg', '₹2,880 COD'),
      _DeliveryRow('Imran', '11 orders', '19 min avg', '₹1,450 COD'),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TrustMeds Ops Panel'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pharmacist'),
              Tab(text: 'Delivery'),
              Tab(text: 'Admin'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OpsSection(
              heading: 'Pharmacist View',
              subheading:
                  'Incoming orders, patient details, prescription status, and packing workflow.',
              metrics: summaryCards,
              children: [
                const _SectionTitle('Incoming Orders'),
                ...orderRows.map(_buildOrderTile),
              ],
            ),
            _OpsSection(
              heading: 'Delivery View',
              subheading:
                  'Assigned orders, delivery timings, COD collection, and live order completion tracking.',
              metrics: const [
                _MetricData(
                    'Assigned Today', '23', Icons.assignment_turned_in_rounded),
                _MetricData('Delivered Today', '19', Icons.done_all_rounded),
                _MetricData('Avg Delivery Time', '23 min', Icons.timer_rounded),
                _MetricData(
                    'COD Collected', '₹7,750', Icons.currency_rupee_rounded),
              ],
              children: [
                const _SectionTitle('Delivery Partner Performance'),
                ...deliveryRows.map(_buildDeliveryTile),
              ],
            ),
            _OpsSection(
              heading: 'Admin View',
              subheading:
                  'Today sales records, payment mode split, order performance, and operations metrics.',
              metrics: const [
                _MetricData('UPI Orders', '162', Icons.qr_code_2_rounded),
                _MetricData('Cash Orders', '106', Icons.payments_outlined),
                _MetricData('Avg Order Value', '₹686', Icons.bar_chart_rounded),
                _MetricData(
                    'Failed Deliveries', '7', Icons.warning_amber_rounded),
              ],
              children: const [
                _InsightTile(
                  title: 'Today Sales Snapshot',
                  value: '₹1,84,220',
                  subtitle:
                      'Net sales across medicines, lab tests, and OTC products.',
                ),
                _InsightTile(
                  title: 'Payment Split',
                  value: '60% UPI / 40% Cash',
                  subtitle: 'Live mode-wise payment distribution.',
                ),
                _InsightTile(
                  title: 'Pharmacist Queue',
                  value: '31 orders awaiting review',
                  subtitle:
                      'Orders that still need prescription verification or alternate suggestions.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildOrderTile(_OrderRow row) {
    return _InsightTile(
      title: '${row.orderId} • ${row.patientName}',
      value: '${row.paymentMode} • ${row.status}',
      subtitle: 'Last updated ${row.updatedAgo}',
    );
  }

  static Widget _buildDeliveryTile(_DeliveryRow row) {
    return _InsightTile(
      title: row.partnerName,
      value: '${row.orderCount} • ${row.averageTime}',
      subtitle: row.codCollection,
    );
  }
}

class _OpsSection extends StatelessWidget {
  final String heading;
  final String subheading;
  final List<_MetricData> metrics;
  final List<Widget> children;

  const _OpsSection({
    required this.heading,
    required this.subheading,
    required this.metrics,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          heading,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          subheading,
          style: const TextStyle(fontSize: 14, color: Color(0xFF62736E)),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              metrics.map((metric) => _MetricCard(metric: metric)).toList(),
        ),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final _MetricData metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(metric.icon, color: const Color(0xFF2D6A5F)),
          const SizedBox(height: 10),
          Text(metric.label, style: const TextStyle(color: Color(0xFF62736E))),
          const SizedBox(height: 6),
          Text(metric.value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _InsightTile({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D6A5F))),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Color(0xFF62736E))),
        ],
      ),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final IconData icon;

  const _MetricData(this.label, this.value, this.icon);
}

class _OrderRow {
  final String orderId;
  final String patientName;
  final String paymentMode;
  final String status;
  final String updatedAgo;

  const _OrderRow(
    this.orderId,
    this.patientName,
    this.paymentMode,
    this.status,
    this.updatedAgo,
  );
}

class _DeliveryRow {
  final String partnerName;
  final String orderCount;
  final String averageTime;
  final String codCollection;

  const _DeliveryRow(
    this.partnerName,
    this.orderCount,
    this.averageTime,
    this.codCollection,
  );
}
