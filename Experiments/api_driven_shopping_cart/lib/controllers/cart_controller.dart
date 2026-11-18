import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends GetxController {
  var items = <CartItem>[].obs;

  static const double taxRate = 0.05;

  void addToCart(Product product) {
    final index = items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      items[index].quantity++;
      items.refresh();
    } else {
      items.add(CartItem(product: product));
    }
  }

  void decreaseQuantity(Product product) {
    final index = items.indexWhere((i) => i.product.id == product.id);
    if (index < 0) return;
    if (items[index].quantity > 1) {
      items[index].quantity--;
      items.refresh();
    } else {
      items.removeAt(index);
    }
  }

  void removeFromCart(Product product) {
    items.removeWhere((i) => i.product.id == product.id);
  }

  int quantityOf(Product product) {
    final index = items.indexWhere((i) => i.product.id == product.id);
    return index >= 0 ? items[index].quantity : 0;
  }

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.total);

  double get tax => subtotal * taxRate;

  double get total => subtotal + tax;
}
