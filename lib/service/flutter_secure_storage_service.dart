  import 'dart:convert';

  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_for_shared_preference/model/account_model.dart';

  import 'package:task_for_shared_preference/service/log_service.dart';

  class SecureService {
    static Future<void> storeUser(Account account) async {
      try {
        const storage = FlutterSecureStorage();
        String? stringUser = jsonEncode(account);
        await storage.write(key: 'user', value: stringUser);
      } catch (e) {
        LogService.w(e.toString());
      }
    }

    static Future<Account?> loadUser() async {
      try {
        const storage = FlutterSecureStorage();
        String? stringUser = await storage.read(key: 'user');
        if (stringUser != null) {
          Map<String, dynamic> map = jsonDecode(stringUser);
          return Account.fromJson(map);
        }
        return null;
      } catch (e) {
        LogService.w(e.toString());
        return null;
      }
    }
  }
