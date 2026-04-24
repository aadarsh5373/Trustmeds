import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'UPI';
  final cartController = Get.find<CartController>();
  final orderController = Get.find<OrderController>();
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: authController.currentUser?.name ?? '');
    _phoneController = TextEditingController(
      text: (authController.currentUser?.phone ?? '')
          .replaceAll(RegExp(r'[^0-9]'), '')
          .replaceFirst(RegExp(r'^91'), ''),
    );
    _instructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Obx(() {
                final address = authController.selectedAddress;
                return _buildSectionCard(
                  icon: Icons.location_on_rounded,
                  title: 'Delivery Address',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed('/addresses'),
                    child: Text('Change',
                        style: GoogleFonts.nunito(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                  child: address == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No address selected',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Get.toNamed('/addresses'),
                              child: const Text('Add an address'),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.softPink,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(address.label,
                                      style: GoogleFonts.nunito(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryDark)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              address.fullAddress,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              '${address.city}, ${address.state} - ${address.pincode}',
                              style: GoogleFonts.nunito(
                                  fontSize: 13, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                );
              }),
              const SizedBox(height: 12),
              _buildSectionCard(
                icon: Icons.person_rounded,
                title: 'Contact Details',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter recipient name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter 10-digit mobile number',
                      prefixIcon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: Validators.validatePhone,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _instructionsController,
                      labelText: 'Delivery Instructions',
                      hintText: 'Flat number, landmark, timing notes',
                      prefixIcon: Icons.notes_rounded,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final prescription = authController.latestPrescription;

                if (prescription.isNotEmpty) {
                  return Column(
                    children: [
                      _buildSectionCard(
                        icon: Icons.description_rounded,
                        title: 'Prescription',
                        trailing: TextButton(
                          onPressed: () => Get.toNamed('/upload-prescription'),
                          child: Text(
                            'Update',
                            style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prescription['patientName'] ?? 'Patient',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${prescription['sourceLabel'] ?? 'Uploaded'} • ${prescription['phone'] ?? ''}',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              prescription['notes'] ?? '',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.upload_file_rounded,
                              color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Need Rx medicines? Upload your prescription before placing the order.',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Get.toNamed('/upload-prescription'),
                            child: const Text('Upload'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),
              // Delivery estimate
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_rounded,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Estimated delivery by ${Formatters.deliveryEstimate()}',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Order Items
              _buildSectionCard(
                icon: Icons.shopping_bag_rounded,
                title: 'Order Items (${cartController.itemCount})',
                child: Obx(() => Column(
                      children: cartController.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.name} x${item.quantity}',
                                  style: GoogleFonts.nunito(
                                      fontSize: 13, color: AppColors.textDark),
                                ),
                              ),
                              Text(
                                Formatters.currency(item.totalPrice),
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )),
              ),
              const SizedBox(height: 16),
              // Payment Method
              _buildSectionCard(
                icon: Icons.payment_rounded,
                title: 'Payment Method',
                child: Column(
                  children: [
                    _buildPaymentOption('UPI', Icons.phone_android_rounded),
                    _buildPaymentOption(
                        'Credit/Debit Card', Icons.credit_card_rounded),
                    _buildPaymentOption(
                        'Net Banking', Icons.account_balance_rounded),
                    _buildPaymentOption(
                        'Cash on Delivery', Icons.money_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Promo code
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppColors.blushPink.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Apply Promo Code',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textLight),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() => Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        Formatters.currency(cartController.total),
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      text: 'Place Order',
                      isLoading: orderController.isLoading.value,
                      onPressed: () async {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        if (authController.selectedAddress == null) {
                          Helpers.showErrorSnackbar(
                              'Please add or select a delivery address');
                          return;
                        }

                        await authController.updateProfile(
                          name: _nameController.text.trim(),
                          phone: _phoneController.text.trim(),
                        );

                        final orderNum = await orderController.placeOrder(
                          paymentMethod: selectedPayment,
                          address: {
                            'label': authController.selectedAddress!.label,
                            'fullAddress':
                                authController.selectedAddress!.fullAddress,
                            'city': authController.selectedAddress!.city,
                            'state': authController.selectedAddress!.state,
                            'pincode': authController.selectedAddress!.pincode,
                            'recipientName': _nameController.text.trim(),
                            'recipientPhone': _phoneController.text.trim(),
                            'instructions': _instructionsController.text.trim(),
                          },
                          prescriptionDetails:
                              authController.latestPrescription,
                        );
                        Get.offNamed('/order-confirmation',
                            arguments: orderNum);
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blushPink.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    final isSelected = selectedPayment == method;
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = method),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textLight,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(width: 10),
            Text(
              method,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.textDark : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
