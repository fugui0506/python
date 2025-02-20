import 'dart:math';

import 'package:cgwallet/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'index.dart';

class CustomerHelpController extends GetxController {
  final state = CustomerHelpState();

  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(MyConfig.app.timePageTransition);
    await updateCustomerHelpData();
  }

  @override
  void onClose() async {
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  Future<void> updateCustomerHelpData() async {
    await state.customerHelpData.update();
    state.isLoading = false;

    // print(state.customerHelpData.toJson());

    if (state.customerHelpData.title.isNotEmpty) {
      if (state.customerHelpData.customerQuestions.isEmpty) {
        state.isNoData = true;
      } else {
        state.isNoData = false;
      }
    } else {
      state.isNoData = true;
    }

    state.chatItems.add(state.customerHelpData);
    state.chatItems.refresh();
  }

  void moveScrollToBottom() async {
    if (scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 200));
      scrollController.jumpTo(scrollController.position.maxScrollExtent,
        // duration: Duration(milliseconds: 300),
        // curve: Curves.linear,
      );
    }
  }

  void moveScrollToTop() async {
    if (scrollController.hasClients) {
      scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void onRefresh() {
    for (var item in state.customerHelpData.customerQuestions) {
      item.isClicked = false;
      for (var question in item.customerQuestionTypes) {
        question.isClicked = false;
      }
    }
    state.chatItems.clear();
    state.chatItems.add(state.customerHelpData);
    state.chatItems.refresh();
    refreshController.refreshCompleted();
  }

  void goCustomerView() {
    final helpCustomers = UserController.to.customerData.value.customer.where((e) => e.customerServiceType == 2).toList();

    Random random = Random();

    int index = random.nextInt(helpCustomers.length);

    UserController.to.goCustomerChatView(
      cert: helpCustomers[index].cret,
      // sysOrderId: sysOrderId,
      apiUrl: UserController.to.customerData.value.urlApi,
      imageUrl: UserController.to.customerData.value.urlImg,
      userId: UserController.to.userInfo.value.user.id,
      tenantId: int.parse(UserController.to.customerData.value.chatUrl),
      avatarUrl: UserController.to.userInfo.value.user.avatarUrl,
      sign: UserController.to.customerData.value.sign,
    );
  }

  void onCustomerQuestions(int index, CustomerQuestionModel data) {
    state.chatItems.add( CustomerUserMessageModel(title: data.title, createTime: MyTimer.getNowTime()));
    state.chatItems.refresh();

    final customerQuestionModel = CustomerQuestionModel.empty();
    customerQuestionModel.createTime = MyTimer.getNowTime();
    customerQuestionModel.title = data.title;
    customerQuestionModel.customerQuestionTypes = data.customerQuestionTypes;

    state.chatItems.add(customerQuestionModel);
    state.chatItems.refresh();

    moveScrollToBottom();
  }

  void onCustomerAnswer(int index, CustomerQuestionTypeModel data) {
    state.chatItems.add( CustomerUserMessageModel(title: data.title, createTime: MyTimer.getNowTime()));
    state.chatItems.refresh();

    final customerQuestionTypeModel = CustomerQuestionTypeModel.empty();
    customerQuestionTypeModel.createTime = MyTimer.getNowTime();
    customerQuestionTypeModel.title = data.title;
    customerQuestionTypeModel.customerAnswer = data.customerAnswer;

    state.chatItems.add(customerQuestionTypeModel);
    state.chatItems.refresh();

    moveScrollToBottom();
  }
}
