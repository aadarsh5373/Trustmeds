import '../../medicines/models/medicine_model.dart';
import '../../lab_tests/models/lab_test_model.dart';

enum CartItemType { medicine, labTest }

class CartItem {
  final MedicineModel? medicine;
  final LabTestModel? labTest;
  final CartItemType type;
  int quantity;

  CartItem({
    this.medicine,
    this.labTest,
    required this.type,
    this.quantity = 1,
  }) : assert((type == CartItemType.medicine && medicine != null) ||
              (type == CartItemType.labTest && labTest != null));

  double get totalPrice {
    if (type == CartItemType.medicine) {
      return medicine!.sellingPrice * quantity;
    } else {
      return labTest!.discountedPrice * quantity;
    }
  }

  double get totalMrp {
    if (type == CartItemType.medicine) {
      return medicine!.mrp * quantity;
    } else {
      return labTest!.price * quantity;
    }
  }

  double get savings => totalMrp - totalPrice;

  String get id => type == CartItemType.medicine ? medicine!.id : labTest!.id;
  String get name => type == CartItemType.medicine ? medicine!.name : labTest!.name;
  String get imageUrl => type == CartItemType.medicine ? medicine!.imageUrl : labTest!.imageUrl;
}
