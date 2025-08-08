import '../plan_controller.dart';
import 'controller_index.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(ProfileController());
    Get.put(FcmController());
    Get.put(TransactionController(), permanent: true);
    Get.put(VerificationController(), permanent: true);

    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<SupportTicketController>(() => SupportTicketController(),
        fenix: true);
    Get.lazyPut<DepositHistoryController>(() => DepositHistoryController(),
        fenix: true);
    Get.lazyPut<WithdrawHistoryController>(() => WithdrawHistoryController(),
        fenix: true);
    Get.lazyPut<WithdrawController>(() => WithdrawController(), fenix: true);
    Get.lazyPut<DepositController>(() => DepositController(), fenix: true);
    Get.lazyPut<NotificationSettingsController>(
        () => NotificationSettingsController(),
        fenix: true);

    Get.lazyPut<ReferralListController>(() => ReferralListController(),
        fenix: true);
    Get.lazyPut<ReferralBonusController>(() => ReferralBonusController(),
        fenix: true);
    Get.lazyPut<PlanHistoryController>(() => PlanHistoryController(),
        fenix: true);
    Get.lazyPut<PlanController>(() => PlanController(), fenix: true);
    Get.lazyPut<ProjectHistoryController>(() => ProjectHistoryController(),
        fenix: true);
    Get.lazyPut<ProjectController>(() => ProjectController(), fenix: true);
    Get.lazyPut<ProductListController>(() => ProductListController(),
        fenix: true);
    Get.lazyPut<ProductManageController>(() => ProductManageController(),
        fenix: true);
    Get.lazyPut<WishlistController>(() => WishlistController(), fenix: true);
    Get.lazyPut<MyOrderController>(() => MyOrderController(), fenix: true);
  }
}
