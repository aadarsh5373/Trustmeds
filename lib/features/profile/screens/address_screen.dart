import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: AppColors.white,
      ),
      body: Obx(() {
        final addresses = authController.addresses;

        if (addresses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No addresses saved yet',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add your delivery address to speed up checkout.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Add Address',
                    width: 180,
                    onPressed: () => _openAddressSheet(authController),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: addresses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final address = addresses[index];
            final isSelected = authController.selectedAddress?.id == address.id;

            return GestureDetector(
              onTap: () async {
                await authController.selectAddress(address.id);
                Helpers.showSuccessSnackbar(
                    '${address.label} address selected');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.blushPink.withOpacity(0.4),
                    width: isSelected ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.softPink.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        address.label.toLowerCase() == 'work'
                            ? Icons.work_rounded
                            : Icons.home_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                address.label,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Selected',
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.fullAddress,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            '${address.city}, ${address.state} - ${address.pincode}',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert_rounded,
                          color: AppColors.textLight, size: 20),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _openAddressSheet(authController, address: address);
                        } else if (value == 'delete') {
                          final confirm = await Helpers.showConfirmDialog(
                            title: 'Delete address',
                            message:
                                'Remove this address from your saved list?',
                            confirmText: 'Delete',
                          );
                          if (confirm == true) {
                            await authController.deleteAddress(address.id);
                            Helpers.showInfoSnackbar('Address deleted');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddressSheet(authController),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Address',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _openAddressSheet(
    AuthController authController, {
    AddressModel? address,
  }) {
    final formKey = GlobalKey<FormState>();
    final labelController = TextEditingController(text: address?.label ?? '');
    final addressController =
        TextEditingController(text: address?.fullAddress ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final pincodeController =
        TextEditingController(text: address?.pincode ?? '');

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    address == null ? 'Add Address' : 'Edit Address',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: labelController,
                    labelText: 'Label',
                    hintText: 'Home, Work, Parents',
                    prefixIcon: Icons.bookmark_rounded,
                    validator: (value) =>
                        Validators.validateRequired(value, 'address label'),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: addressController,
                    labelText: 'Full Address',
                    hintText: 'House no, building, street, landmark',
                    prefixIcon: Icons.location_on_rounded,
                    maxLines: 3,
                    validator: (value) =>
                        Validators.validateRequired(value, 'address'),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: cityController,
                    labelText: 'City',
                    hintText: 'Mumbai',
                    prefixIcon: Icons.location_city_rounded,
                    validator: (value) =>
                        Validators.validateRequired(value, 'city'),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: stateController,
                    labelText: 'State',
                    hintText: 'Maharashtra',
                    prefixIcon: Icons.map_rounded,
                    validator: (value) =>
                        Validators.validateRequired(value, 'state'),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: pincodeController,
                    labelText: 'Pincode',
                    hintText: '400001',
                    prefixIcon: Icons.pin_drop_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: Validators.validatePincode,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          isOutlined: true,
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: address == null ? 'Save' : 'Update',
                          onPressed: () async {
                            if (!(formKey.currentState?.validate() ?? false)) {
                              return;
                            }

                            await authController.saveAddress(
                              AddressModel(
                                id: address?.id ??
                                    'addr_${DateTime.now().millisecondsSinceEpoch}',
                                label: labelController.text.trim(),
                                fullAddress: addressController.text.trim(),
                                pincode: pincodeController.text.trim(),
                                city: cityController.text.trim(),
                                state: stateController.text.trim(),
                              ),
                            );

                            if (address == null) {
                              await authController.selectAddress(
                                authController.addresses.last.id,
                              );
                            }

                            Get.back();
                            Helpers.showSuccessSnackbar(
                              address == null
                                  ? 'Address saved successfully'
                                  : 'Address updated successfully',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
