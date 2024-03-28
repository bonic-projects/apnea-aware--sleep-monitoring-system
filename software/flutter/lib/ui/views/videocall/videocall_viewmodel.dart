import 'package:apnea_aware/app/app.locator.dart';
import 'package:apnea_aware/app/app.router.dart';
import 'package:apnea_aware/services/videosdk_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VideocallViewModel extends ReactiveViewModel {
  final _videosdkService = locator<VideosdkService>();

  String get sdkToken => _videosdkService.token;

  final _navigationService = locator<NavigationService>();

  void alertdialog() {
    _navigationService.navigateTo(Routes.alertView);
  }
}
