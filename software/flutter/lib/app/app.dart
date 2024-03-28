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

import 'package:apnea_aware/services/database_service.dart';
import 'package:apnea_aware/ui/views/detailed/detailed_view.dart';

import 'package:apnea_aware/ui/views/movement/movement_view.dart';
import 'package:apnea_aware/ui/views/doctor/doctor_view.dart';
import 'package:apnea_aware/ui/views/patient/patient_view.dart';
import 'package:apnea_aware/services/videosdk_service.dart';
import 'package:apnea_aware/ui/views/videocall/videocall_view.dart';

import 'package:apnea_aware/ui/views/alert/alert_view.dart';
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

    MaterialRoute(page: DetailedView),

    MaterialRoute(page: MovementView),
    MaterialRoute(page: DoctorView),
    MaterialRoute(page: PatientView),
    MaterialRoute(page: VideocallView),

    MaterialRoute(page: AlertView),
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
    LazySingleton(classType: VideosdkService),
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
