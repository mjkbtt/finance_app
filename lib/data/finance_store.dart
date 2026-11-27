import 'package:material_ui/material_ui.dart';

import 'models/finance_transaction.dart';

class FinanceStore extends ChangeNotifier {
  FinanceStore._();

  static final instance = FinanceStore._();

  // Хүлээгдэж буй гүйлгээнүүдийн амьд жагсаалт
  final List<FinanceTransaction> _pending = List.of(pendingTransactions);

  List<FinanceTransaction> get pending => List.unmodifiable(_pending);

  void addPending(FinanceTransaction transaction) {
    _pending.insert(0, transaction); // Хамгийн дээр нь нэмнэ
    notifyListeners(); // Дэлгэцүүдэд "шинэчлэгдлээ" гэж мэдэгдэнэ
  }
}
