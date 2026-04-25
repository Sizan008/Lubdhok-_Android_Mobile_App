import 'package:go_router/go_router.dart';
import 'package:lubdhok/core/router/route_names.dart';
import 'package:lubdhok/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:lubdhok/features/admin/presentation/create_campaign_screen.dart';
import 'package:lubdhok/features/admin/presentation/manage_items_screen.dart';
import 'package:lubdhok/features/admin/presentation/pending_donations_screen.dart';
import 'package:lubdhok/features/admin/presentation/update_used_quantity_screen.dart';
import 'package:lubdhok/features/auth/presentation/forgot_password_screen.dart';
import 'package:lubdhok/features/auth/presentation/login_screen.dart';
import 'package:lubdhok/features/auth/presentation/signup_screen.dart';
import 'package:lubdhok/features/auth/presentation/verify_email_screen.dart';
import 'package:lubdhok/features/donor/presentation/campaign_details_screen.dart';
import 'package:lubdhok/features/donor/presentation/donation_form_screen.dart';
import 'package:lubdhok/features/donor/presentation/donation_history_screen.dart';
import 'package:lubdhok/features/donor/presentation/donor_home_screen.dart';
import 'package:lubdhok/features/donor/presentation/friction_result_screen.dart';
import 'package:lubdhok/features/donor/presentation/search_campaign_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.signup,
      builder: (_, __) => const SignupScreen(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RouteNames.verifyEmail,
      builder: (_, __) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: RouteNames.donorHome,
      builder: (_, __) => const DonorHomeScreen(),
    ),
    GoRoute(
      path: RouteNames.adminDashboard,
      builder: (_, __) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: RouteNames.searchCampaign,
      builder: (_, __) => const SearchCampaignScreen(),
    ),
    GoRoute(
      path: RouteNames.campaignDetails,
      builder: (context, state) {
        final id = state.extra as int;
        return CampaignDetailsScreen(campaignId: id);
      },
    ),
    GoRoute(
      path: RouteNames.donationForm,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return DonationFormScreen(
          campaignId: args['campaignId'] as int,
          itemId: args['itemId'] as int,
          itemName: args['itemName'] as String,
          itemStatus: args['itemStatus'] as String,
        );
      },
    ),
    GoRoute(
      path: RouteNames.frictionResult,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return FrictionResultScreen(
          itemName: args['itemName'] as String,
          status: args['status'] as String,
          message: args['message'] as String?,
        );
      },
    ),
    GoRoute(
      path: RouteNames.donationHistory,
      builder: (_, __) => const DonationHistoryScreen(),
    ),
    GoRoute(
      path: RouteNames.createCampaign,
      builder: (_, __) => const CreateCampaignScreen(),
    ),
    GoRoute(
      path: RouteNames.manageItems,
      builder: (context, state) {
        final id = state.extra as int;
        return ManageItemsScreen(campaignId: id);
      },
    ),
    GoRoute(
      path: RouteNames.pendingDonations,
      builder: (context, state) {
        final id = state.extra as int;
        return PendingDonationsScreen(campaignId: id);
      },
    ),
    GoRoute(
      path: RouteNames.updateUsedQuantity,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return UpdateUsedQuantityScreen(
          campaignId: args['campaignId'] as int,
          itemId: args['itemId'] as int,
          itemName: args['itemName'] as String,
        );
      },
    ),
    GoRoute(
      path: RouteNames.frictionResult,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return FrictionResultScreen(
          itemName: args['itemName'] as String,
          status: args['status'] as String,
          message: args['message'] as String?,
          suggestedQuantity: args['suggestedQuantity'] as int?,
          betterAlternative: args['betterAlternative'] as String?,
        );
      },
    ),
  ],
);