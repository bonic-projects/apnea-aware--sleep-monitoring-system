import 'package:apnea_aware/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:apnea_aware/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:apnea_aware/ui/views/home/home_view.dart';
import 'package:apnea_aware/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:apnea_aware/ui/views/register/register_view.dart';
import 'package:apnea_aware/ui/views/login_register/login_register_view.dart';
import 'package:apnea_aware/ui/views/login/login_view.dart';
import 'package:apnea_aware/services/firestore_service.dart';
import 'package:apnea_aware/services/user_service.dart';
import 'package:apnea_aware/ui/views/heart_rate/heart_rate_view.dart';

import 'package:apnea_aware/ui/views/accerelator/accerelator_view.dart';
import 'package:apnea_aware/services/database_service.dart';
import 'package:apnea_aware/ui/views/detailed/detailed_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: LoginRegisterView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HeartRateView),

    MaterialRoute(page: AccerelatorView),
    MaterialRoute(page: DetailedView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),

    LazySingleton(classType: DatabaseService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
