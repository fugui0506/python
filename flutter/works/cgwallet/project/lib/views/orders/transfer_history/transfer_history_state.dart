import 'package:cgwallet/common/common.dart';
import 'package:get/get.dart';

class TransferHistoryState {
  final title = Lang.transferHistoryViewTitle.tr;

  final orderTransferHistoryList = OrderTransferListModel.empty().obs;

  final responseData = ResponseTransferHistory(page: 1, pageSize: 10, dateType: 3).obs;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }
}

class ResponseTransferHistory {
  int page;
  int pageSize;
  int dateType;

  ResponseTransferHistory({required this.page, required this.pageSize, required this.dateType});

  Map<String, dynamic> toJson() => {
    "page": page,
    "pageSize": pageSize,
    "dateType": dateType,
  };
}