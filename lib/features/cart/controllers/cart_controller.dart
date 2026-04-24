import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../../medicines/models/medicine_model.dart';
import '../../lab_tests/models/lab_test_model.dart';
import '../../../core/utils/helpers.dart';

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;
  final RxBool isLoading = false.obs;

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalMrp => items.fold(0.0, (sum, item) => sum + item.totalMrp);

  double get totalSavings => totalMrp - subtotal;

  double get deliveryFee => subtotal > 499 ? 0 : 49;

  double get total => subtotal + deliveryFee;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(MedicineModel medicine) {
    final existingIndex = items.indexWhere(
        (item) => item.type == CartItemType.medicine && item.id == medicine.id);

    if (existingIndex >= 0) {
      items[existingIndex].quantity++;
      items.refresh();
    } else {
      items.add(CartItem(medicine: medicine, type: CartItemType.medicine));
    }
    update(['cart_badge']);
    Helpers.showSuccessSnackbar('${medicine.name} added to cart');
  }

  void addLabTestToCart(LabTestModel test) {
    final existingIndex = items.indexWhere(
        (item) => item.type == CartItemType.labTest && item.id == test.id);

    if (existingIndex >= 0) {
      Helpers.showInfoSnackbar('${test.name} is already in the cart');
    } else {
      items.add(CartItem(labTest: test, type: CartItemType.labTest));
      update(['cart_badge']);
      Helpers.showSuccessSnackbar('${test.name} added to cart');
    }
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      items[index].quantity = quantity;
      items.refresh();
      update(['cart_badge']);
    }
  }

  void incrementQuantity(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0 && items[index].quantity < 10) {
      // Lab tests usually only have quantity 1 per person unless specified, but for mock, let's keep logic general
      if (items[index].type == CartItemType.labTest &&
          items[index].quantity >= 4) {
        Helpers.showInfoSnackbar('Maximum 4 members per home collection');
        return;
      }
      items[index].quantity++;
      items.refresh();
      update(['cart_badge']);
    }
  }

  void decrementQuantity(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
        items.refresh();
        update(['cart_badge']);
      } else {
        removeItem(itemId);
      }
    }
  }

  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
    update(['cart_badge']);
    Helpers.showInfoSnackbar('Item removed from cart');
  }

  void clearCart() {
    items.clear();
    update(['cart_badge']);
  }
}
