import 'package:southsea_cinema/models/basket_item.dart';

class BasketRepository {
  static const double serviceCharge = 4.0;

  BasketRepository._internal();

  static final BasketRepository instance = BasketRepository._internal();

  final List<BasketItem> _items = [];

  List<BasketItem> getItems() => List<BasketItem>.unmodifiable(_items);

  void addItem(BasketItem item) {
    _items.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int getTotalItems() {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  int get totalItemCount => getTotalItems();

  double getTotal() {
    return _items.fold(0.0, (total, item) => total + item.lineTotal);
  }

  double getServiceCharge() => _items.isEmpty ? 0.0 : serviceCharge;

  double getTotalDue() => getTotal() + getServiceCharge();

  void clear() {
    _items.clear();
  }
}
