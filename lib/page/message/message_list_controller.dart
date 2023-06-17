import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:metting/tool/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../base/BaseController.dart';
import '../../tool/emc_helper.dart';
import '../../widget/loading.dart';
import '../../widget/my_toast.dart';
import 'conversations_bean.dart';

class MessageListController extends BaseController {
  List<ConversationBean> messageBean = [];
  int pageNum = 1;

  @override
  void onInit() {
    super.onInit();
    refreshData(null);
  }

  void refreshData(RefreshController? refreshController) async {
    pageNum = 1;
    final list = await EmcHelper.getAllConversationsMessage(pageNum: pageNum);
    messageBean.clear();
    if (list.isNotEmpty) {
      pageNum++;
      messageBean.addAll(list);
      update(['list']);
    }
    logger.i('refreshData refreshCompleted $refreshController');
    refreshController?.refreshCompleted();
  }

  void loadData(RefreshController refreshController) async {
    final list = await EmcHelper.getAllConversationsMessage(pageNum: pageNum);
    if (list.isNotEmpty) {
      pageNum++;
      messageBean.addAll(list);
      update(['list']);
    }
    if (list.length < 30) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
  }

  void delCon(ConversationBean bean, bool isDeleteMessage) async {
    LoadingUtils.showLoading(msg: '删除中...');
    final isSuccess = await EmcHelper.delConversation(bean.id,
        isDeleteMessage: isDeleteMessage);
    if (isSuccess) {
      messageBean.remove(bean);
      update(['list']);
      MyToast.show('删除成功');
    }
    LoadingUtils.dismiss();
  }

  void newMessageReceive(EMMessage emMessage) async {
    logger.i("newMessageReceive -->message$emMessage  c$this");
    final coId = emMessage.conversationId;
    if (coId != null) {
      EMConversation? conversation =
          await EMClient.getInstance.chatManager.getConversation(coId);
      logger.i("newMessageReceive -->message$conversation");
      if (conversation != null) {
        ConversationBean? targetMessageBean; //1686578917396  1686578929269
        for (var element in messageBean) {
          if (element.id == emMessage.conversationId) {
            targetMessageBean = element;
            break;
          }
        }
        if (targetMessageBean == null) {
          logger.i("targetMessageBean ==null");
          final bean = ConversationBean();
          await bean.updateConversation(conversation);
          await EmcHelper.setConversationBeanUserInfo(bean, conversation.id);
          messageBean.insert(0, bean);
          update(['list']);
        } else {
          await targetMessageBean.updateConversation(conversation);
          messageBean.sort((a, b) =>
              (b.newMsg?.serverTime ?? 0).compareTo(a.newMsg?.serverTime ?? 0));
          update(['list']);
        }
      }
    }
  }

  void refreshConversationData(ConversationBean bean) async {
    EMConversation? conversation =
        await EMClient.getInstance.chatManager.getConversation(bean.id);
    if (conversation != null) {
      await bean.updateConversation(conversation);
      update(['list']);
    }
  }
}
