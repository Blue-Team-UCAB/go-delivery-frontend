import 'package:go_delivery_frontend/domain/datasources/cart/cart_local_storage_datasource.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/infrastructure/entities/cart/isar_cartitem.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


class CartIsarLocalStorageDatasource extends CartLocalStorageDatasource{

  late Future<Isar> db;

  CartIsarLocalStorageDatasource () {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([IsarCartitemSchema],directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> addCartItem(CartItem item) async {
    final isar = await db;

    final isarItem = await isar.isarCartitems
      .filter().idEqualTo(item.id).findFirst();
    
    if (isarItem == null){
      final cartItem = CartItemMapper.fromCartItem(item).toIsarCartItemEntity();
      isar.writeTxnSync(() => isar.isarCartitems.putSync(cartItem));
    }
    
  }

  @override
  Future<List<CartItem>> loadCartItems() async {
    final isar = await db;
    final items = await isar.isarCartitems.where().findAll();

    final List<CartItem> newItems = items.map((item){
      final newItem = CartItemMapper.fromIsarCartItem(item).toCartItemEntity();
      return newItem;
    }).toList();

    return newItems;

  }
  
  @override
  Future<void> removeCartItem(String id) async {
    final isar = await db;
    final isarItem = await isar.isarCartitems
      .filter().idEqualTo(id).findFirst();

    if (isarItem != null) {
      isar.writeTxnSync(() => isar.isarCartitems.deleteSync(isarItem.isarId!));
      return;
    }
    
    return;
  }

  @override
  Future<void> operateCartItem(String id, int quantity) async {
    final isar = await db;
    final isarItem = await isar.isarCartitems
      .filter().idEqualTo(id).findFirst();

    if (isarItem != null) {
      isar.writeTxnSync(() => isar.isarCartitems.deleteSync(isarItem.isarId!));
      final newItem = isarItem.copyWith(quantity: isarItem.quantity + quantity);
      isar.writeTxnSync(() => isar.isarCartitems.putSync(newItem));
    }
    
    return;
  }
}