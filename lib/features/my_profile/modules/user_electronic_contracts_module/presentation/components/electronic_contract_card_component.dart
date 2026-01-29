import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/entity/user_electronic_contract_entity.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'dart:io';
import '../../../../../../core/services/dateformatter_service.dart';
import '../../../../../../core/services/get_file_permission.dart';

class ElectronicContractCardComponent extends StatefulWidget {
  final UserElectronicContractEntity contract;
  final double width;
  final double height;
  final bool? isDesktopMode;

  const ElectronicContractCardComponent({
    super.key,
    required this.contract,
    required this.width,
    required this.height,
    this.isDesktopMode = false,
  });

  @override
  State<ElectronicContractCardComponent> createState() => _ElectronicContractCardComponentState();
}

class _ElectronicContractCardComponentState extends State<ElectronicContractCardComponent> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  Future<void> _handleContractAction() async {
    String url = widget.contract.contractUrl;
    await _downloadAndStoreFile(url);
  }

  Future<void> _downloadAndStoreFile(String url) async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    bool hasPermission = await FilePermissionService.checkFilePermission(context);
    if (!hasPermission) {
      setState(() => _isDownloading = false);
      return;
    }

    try {
      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory();

      Response response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      String contentType = response.headers.value('content-type') ?? 'application/octet-stream';
      String fileExtension = _getFileExtension(contentType);
      String fileName = 'contract_${widget.contract.id}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final filePath = '${directory.path}/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(response.data);

      setState(() => _isDownloading = false);
      _showSnackBar('تم تنزيل الملف بنجاح: $fileName');
      await _openDownloadedFile(filePath);
    } catch (e) {
      setState(() => _isDownloading = false);
      _showSnackBar('حدث خطأ أثناء تنزيل الملف: ${e.toString()}');
    }
  }

  String _getFileExtension(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'application/pdf':
        return '.pdf';
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'image/gif':
        return '.gif';
      default:
        return '.pdf';
    }
  }

  Future<void> _openDownloadedFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        _showSnackBar('لا يمكن فتح الملف: ${result.message}');
      } else {
        _showSnackBar('تم فتح الملف بنجاح');
      }
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء فتح الملف: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    CustomSnackBar.show(
      context: context,
      message: message,
      type: message.contains('خطأ') ? SnackBarType.error : SnackBarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 1200;
    final isDesktop = widget.isDesktopMode ?? isLargeScreen;

    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 4 : 8,
        horizontal: isDesktop ? 0 : 4,
      ),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(_getBorderRadius(isSmallScreen, isDesktop)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: isSmallScreen ? 5 : 8,
            offset: Offset(0, isSmallScreen ? 2 : 3),
          ),
        ],
      ),
      child: Padding(
        padding: _getPadding(isSmallScreen, isDesktop),
        child: isDesktop
            ? _buildDesktopLayout(context, isSmallScreen)
            : _buildMobileLayout(context, isSmallScreen),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isSmallScreen) {
    return Row(
      children: [
        // Icon Container
        Container(
          width: _getIconSize(isSmallScreen),
          height: _getIconSize(isSmallScreen),
          padding: EdgeInsets.all(_getIconPadding(isSmallScreen)),
          decoration: BoxDecoration(
            color: ColorManager.yellowColor,
            shape: BoxShape.circle,
          ),
          child: SvgImageComponent(
            iconPath: AppAssets.clipIcon,
          ),
        ),

        SizedBox(width: _getSpacing(isSmallScreen)),

        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${LocaleKeys.contract.tr()} ${widget.contract.contractName}",
                style: getBoldStyle(
                  color: ColorManager.blackColor,
                  fontSize: _getTitleFontSize(isSmallScreen),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: _getTextSpacing(isSmallScreen)),
              Text(
                DateFormatterService.getFormattedDate(widget.contract.dateCreated),
                style: getMediumStyle(
                  color: ColorManager.grey2,
                  fontSize: _getDateFontSize(isSmallScreen),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        SizedBox(width: _getSpacing(isSmallScreen)),

        // Download Button
        _buildDownloadButton(isSmallScreen),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isSmallScreen) {
    return Row(
      children: [
        // Icon Container
        Container(
          width: _getDesktopIconSize(),
          height: _getDesktopIconSize(),
          padding: EdgeInsets.all(_getDesktopIconPadding()),
          decoration: BoxDecoration(
            color: ColorManager.yellowColor,
            shape: BoxShape.circle,
          ),
          child: SvgImageComponent(
            iconPath: AppAssets.clipIcon,
          ),
        ),

        SizedBox(width: _getDesktopSpacing()),

        // Text Content - Expanded for desktop
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${LocaleKeys.contract.tr()} ${widget.contract.contractName}",
                style: getBoldStyle(
                  color: ColorManager.blackColor,
                  fontSize: _getDesktopTitleFontSize(),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: _getDesktopTextSpacing()),
              Text(
                DateFormatterService.getFormattedDate(widget.contract.dateCreated),
                style: getMediumStyle(
                  color: ColorManager.greenColor,
                  fontSize: _getDesktopDateFontSize(),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        SizedBox(width: _getDesktopSpacing()),

        // Contract Type Badge (Desktop only)
        if (!isSmallScreen) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: _getBadgePaddingHorizontal(),
              vertical: _getBadgePaddingVertical(),
            ),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getContractType(),
              style: getMediumStyle(
                color: ColorManager.primaryColor,
                fontSize: _getBadgeFontSize(),
              ),
            ),
          ),
          SizedBox(width: _getDesktopSpacing()),
        ],

        // Download Button
        _buildDesktopDownloadButton(),
      ],
    );
  }

  Widget _buildDownloadButton(bool isSmallScreen) {
    return IconButton(
      onPressed: _isDownloading ? null : _handleContractAction,
      iconSize: _getIconButtonSize(isSmallScreen),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: _getIconButtonSize(isSmallScreen),
        minHeight: _getIconButtonSize(isSmallScreen),
      ),
      icon: _isDownloading
          ? SizedBox(
        width: _getProgressIndicatorSize(isSmallScreen),
        height: _getProgressIndicatorSize(isSmallScreen),
        child: CircularProgressIndicator(
          value: _downloadProgress > 0 ? _downloadProgress : null,
          strokeWidth: _getProgressIndicatorStrokeWidth(isSmallScreen),
          color: ColorManager.primaryColor,
        ),
      )
          : SvgImageComponent(
        color: Colors.black,
        iconPath: AppAssets.downloadIcon,
        width: _getDownloadIconSize(isSmallScreen),
        height: _getDownloadIconSize(isSmallScreen),
      ),
      tooltip: 'تنزيل العقد',
    );
  }

  Widget _buildDesktopDownloadButton() {
    return ElevatedButton.icon(
      onPressed: _isDownloading ? null : _handleContractAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: _getDesktopButtonPaddingHorizontal(),
          vertical: _getDesktopButtonPaddingVertical(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      icon: _isDownloading
          ? SizedBox(
        width: _getDesktopProgressIndicatorSize(),
        height: _getDesktopProgressIndicatorSize(),
        child: CircularProgressIndicator(
          value: _downloadProgress > 0 ? _downloadProgress : null,
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : SvgImageComponent(
        color: Colors.white,
        iconPath: AppAssets.downloadIcon,
        width: _getDesktopDownloadIconSize(),
        height: _getDesktopDownloadIconSize(),
      ),
      label: Text(
        _isDownloading ? LocaleKeys.completed.tr() : LocaleKeys.completed.tr(),
        style: getMediumStyle(
          color: Colors.white,
          fontSize: _getDesktopButtonFontSize(),
        ),
      ),
    );
  }

  String _getContractType() {
    // Implémentez la logique pour déterminer le type de contrat
    return "PDF"; // Exemple
  }

  // Méthodes utilitaires pour les valeurs responsives - Mobile
  double _getIconSize(bool isSmallScreen) {
    if (isSmallScreen) return 32;
    return 40;
  }

  double _getIconPadding(bool isSmallScreen) {
    if (isSmallScreen) return 6;
    return 8;
  }

  double _getSpacing(bool isSmallScreen) {
    if (isSmallScreen) return 8;
    return 12;
  }

  double _getTitleFontSize(bool isSmallScreen) {
    if (isSmallScreen) return FontSize.s14;
    return FontSize.s16;
  }

  double _getDateFontSize(bool isSmallScreen) {
    if (isSmallScreen) return FontSize.s10;
    return FontSize.s12;
  }

  double _getTextSpacing(bool isSmallScreen) {
    if (isSmallScreen) return 2;
    return 4;
  }

  double _getIconButtonSize(bool isSmallScreen) {
    if (isSmallScreen) return 32;
    return 40;
  }

  double _getProgressIndicatorSize(bool isSmallScreen) {
    if (isSmallScreen) return 16;
    return 20;
  }

  double _getProgressIndicatorStrokeWidth(bool isSmallScreen) {
    if (isSmallScreen) return 2;
    return 3;
  }

  double _getDownloadIconSize(bool isSmallScreen) {
    if (isSmallScreen) return 18;
    return 22;
  }

  EdgeInsets _getPadding(bool isSmallScreen, bool isDesktop) {
    if (isDesktop) return EdgeInsets.all(20);
    if (isSmallScreen) return EdgeInsets.all(12);
    return EdgeInsets.all(16);
  }

  double _getBorderRadius(bool isSmallScreen, bool isDesktop) {
    if (isDesktop) return 16;
    if (isSmallScreen) return 12;
    return 14;
  }

  // Méthodes utilitaires pour les valeurs responsives - Desktop
  double _getDesktopIconSize() => 48;
  double _getDesktopIconPadding() => 10;
  double _getDesktopSpacing() => 16;
  double _getDesktopTitleFontSize() => FontSize.s18;
  double _getDesktopDateFontSize() => FontSize.s14;
  double _getDesktopTextSpacing() => 6;
  double _getDesktopButtonPaddingHorizontal() => 16;
  double _getDesktopButtonPaddingVertical() => 12;
  double _getDesktopProgressIndicatorSize() => 18;
  double _getDesktopDownloadIconSize() => 20;
  double _getDesktopButtonFontSize() => FontSize.s14;
  double _getBadgePaddingHorizontal() => 12;
  double _getBadgePaddingVertical() => 6;
  double _getBadgeFontSize() => FontSize.s12;
}