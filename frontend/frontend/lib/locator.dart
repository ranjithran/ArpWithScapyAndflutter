import 'package:frontend/Core/Db/db_create_init.dart';
import 'package:frontend/Core/Db/ip_look_up.dart';
import 'package:frontend/Core/Services/dio_client.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/Core/Services/iplookup_service.dart';
import 'package:frontend/Core/Services/socket_client.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model2.dart';
import 'package:frontend/Core/ViewModel/left_bar_view_model.dart';
import 'package:frontend/Core/ViewModel/network_speed_viewmodel.dart';
import 'package:frontend/Core/ViewModel/dashboardviewmodel.dart';
import 'package:frontend/Dialog/dialog_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'Core/Db/packet_table.dart';
import 'Core/ViewModel/attack_view_model.dart';
import 'Core/ViewModel/host_viewmodel.dart';

final locator = GetIt.I;
final logger = Logger(
  
  printer: PrettyPrinter(
    printEmojis: true,
    errorMethodCount: 10,
    methodCount: 10,
    
  ),
);

void setupLocators() {
  locator.registerLazySingleton(() => LeftBarViewModel());
  locator.registerLazySingleton(() => DioClient().init());
  locator.registerLazySingleton(() => NetworkInfo());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AttackViewModel());
  locator.registerLazySingleton(
    () => SocketClientForMe().getSocket(),
  );
  //
  locator.registerLazySingleton(() => VictimsViewModel());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => DBCreateInit().init());
  locator.registerLazySingleton(() => IpLookUpService());
  locator.registerLazySingleton(() => IpLookUpTable());
  locator.registerLazySingleton(() => PacketTable());
  locator.registerLazySingleton(() => DashBoardViewModel());
  locator.registerLazySingleton(() => NetWorkSpeedViewModel());
  locator.registerLazySingleton(() => CustomAppViewModel2());
}
