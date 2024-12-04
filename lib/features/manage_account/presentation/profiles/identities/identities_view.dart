import 'package:core/presentation/extensions/color_extension.dart';
import 'package:core/presentation/views/button/tmail_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/base/setting_detail_view_builder.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/profiles/identities/identities_controller.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/profiles/identities/widgets/identity_list_tile_builder.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/profiles/identities/widgets/identity_loading_widget.dart';
import 'package:tmail_ui_user/features/manage_account/presentation/profiles/widgets/profiles_header_widget.dart';
import 'package:tmail_ui_user/main/localizations/app_localizations.dart';

class IdentitiesView extends GetWidget<IdentitiesController> {

  const IdentitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingDetailViewBuilder(
      responsiveUtils: controller.responsiveUtils,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.responsiveUtils.isWebDesktop(context))
            ...[
              ProfilesHeaderWidget(
                imagePaths: controller.imagePaths,
                responsiveUtils: controller.responsiveUtils,
              ),
              const Divider(color: AppColor.colorDivider),
            ],
          Obx(() => IdentityLoadingWidget(
            identityViewState: controller.identitiesViewState.value,
          )),
          Flexible(
            child: Obx(() => ListView.separated(
              shrinkWrap: true,
              itemCount: controller.listAllIdentities.length + 1,
              padding: const EdgeInsetsDirectional.only(start: 40, end: 40, bottom: 8),
              itemBuilder: (context, index) {
                if (index == controller.listAllIdentities.length) {
                  return Divider(color: Colors.black.withOpacity(.01));
                }

                return Obx(() => IdentityListTileBuilder(
                  imagePaths: controller.imagePaths,
                  identity: controller.listAllIdentities[index],
                  identitySelected: controller.identitySelected.value,
                  mapIdentitySignatures: controller.mapIdentitySignatures,
                  signatureViewState: controller.signatureViewState.value,
                  onEditIdentityAction: (identitySelected) =>
                      controller.goToEditIdentity(context, identitySelected),
                  onDeleteIdentityAction: (identitySelected) =>
                      controller.openConfirmationDialogDeleteIdentityAction(context, identitySelected),
                ));
              },
              separatorBuilder: (_, __) =>
                Divider(color: Colors.black.withOpacity(.08)),
            )),
          ),
          TMailButtonWidget(
            key: const Key('create_new_profile_button'),
            text: AppLocalizations.of(context).createNewProfile,
            icon: controller.imagePaths.icAddNewFolder,
            backgroundColor: AppColor.colorTextButton,
            borderRadius: 10,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 55, vertical: 16),
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 16),
            iconSize: 24,
            iconSpace: 2,
            maxLines: 1,
            flexibleText: true,
            mainAxisSize: MainAxisSize.min,
            iconColor: Colors.white,
            onTapActionCallback: () => controller.goToCreateNewIdentity(context),
          ),
        ]
      )
    );
  }
}