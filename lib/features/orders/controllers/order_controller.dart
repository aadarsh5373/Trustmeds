import 'package:get/get.dart';
import '../models/order_model.dart';
import '../../../core/utils/formatters.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/models/cart_model.dart';

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);

  Future<String> placeOrder({
    required String paymentMethod,
    Map<String, dynamic>? address,
    Map<String, dynamic>? prescriptionDetails,
    Map<String, dynamic>? customerDetails,
  }) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    final cart = Get.find<CartController>();
    final orderNumber = Formatters.orderNumber();

    final order = OrderModel(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'mock_user_001',
      orderNumber: orderNumber,
      items: cart.items
          .map((item) => OrderItem(
                medicineId: item.id,
                medicineName: item.type == CartItemType.medicine
                    ? item.medicine!.name
                    : '${item.labTest!.name} (Lab Test)',
                quantity: item.quantity,
                price: item.type == CartItemType.medicine
                    ? item.medicine!.sellingPrice
                    : item.labTest!.discountedPrice,
                imageUrl: item.imageUrl,
              ))
          .toList(),
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      discount: 0,
      total: cart.total,
      paymentMethod: paymentMethod,
      paymentStatus: 'paid',
      orderStatus: 'placed',
      address: address ??
          {
            'label': 'Home',
            'fullAddress': '42, Sunshine Apartments, MG Road, Mumbai 400001',
            'city': 'Mumbai',
          },
      prescriptionUrl: prescriptionDetails?['sourceLabel'],
      estimatedDelivery: DateTime.now().add(const Duration(days: 2)),
      placedAt: DateTime.now(),
    );

    orders.insert(0, order);
    currentOrder.value = order;
    cart.clearCart();

    isLoading.value = false;
    return orderNumber;
  }
}
