
import '../database/get_storage_manager.dart';
import 'emc_helper.dart';

class AccountUtils{
  static void logoutDataHandler(){
    GStorage.logoutClear();
    EmcHelper.signOut();
  }
}