import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/custom_image.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/services/dateformatter_service.dart';
import 'package:enmaa/core/services/get_file_permission.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/entity/user_electronic_contract_entity.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  State<ElectronicContractCardComponent> createState() =>
      _ElectronicContractCardComponentState();
}

class _ElectronicContractCardComponentState
    extends State<ElectronicContractCardComponent> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  Future<void> _handleContractAction() async {
    if (widget.contract.contractUrl.isEmpty) {
      _showSnackBar('Le contrat est indisponible', SnackBarType.error);
      return;
    }

    await _downloadAndStoreFile(widget.contract.contractUrl);
  }

  void _openContractPreview() {
    if (widget.contract.contractUrl.isEmpty) {
      _showSnackBar('Le contrat est indisponible', SnackBarType.error);
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.65,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 10, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.contract.propertyTitle.isNotEmpty
                                  ? widget.contract.propertyTitle
                                  : widget.contract.contractName,
                              style: getBoldStyle(
                                color: ColorManager.blackColor,
                                fontSize: FontSize.s16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: [
                                _buildBadge(
                                  _getOperationLabel(),
                                  color: _getOperationColor(),
                                ),
                                if (widget.contract.propertyType.isNotEmpty)
                                  _buildBadge(widget.contract.propertyType),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _handleContractAction,
                        icon: Icon(
                          Icons.download_rounded,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: ColorManager.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: ColorManager.grey3),
                Expanded(
                  child: SfPdfViewer.network(
                    widget.contract.contractUrl,
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _downloadAndStoreFile(String url) async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    final hasPermission =
        await FilePermissionService.checkFilePermission(context);
    if (!hasPermission) {
      setState(() => _isDownloading = false);
      return;
    }

    try {
      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory();

      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      final contentType =
          response.headers.value('content-type') ?? 'application/pdf';
      final fileExtension = _getFileExtension(contentType);
      final fileName =
          'contract_${widget.contract.id}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(response.data);

      if (mounted) setState(() => _isDownloading = false);
      _showSnackBar('Contrat telecharge avec succes', SnackBarType.success);
      await _openDownloadedFile(filePath);
    } catch (_) {
      if (mounted) setState(() => _isDownloading = false);
      _showSnackBar('Erreur lors du telechargement', SnackBarType.error);
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
      default:
        return '.pdf';
    }
  }

  Future<void> _openDownloadedFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      _showSnackBar('Impossible d ouvrir le fichier', SnackBarType.error);
    }
  }

  void _showSnackBar(String message, SnackBarType type) {
    if (!mounted) return;
    CustomSnackBar.show(context: context, message: message, type: type);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = widget.isDesktopMode ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openContractPreview,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: widget.width,
          constraints: BoxConstraints(minHeight: widget.height),
          margin: EdgeInsets.symmetric(
            vertical: isDesktop ? 8 : 6,
            horizontal: isDesktop ? 0 : 4,
          ),
          decoration: BoxDecoration(
            color: ColorManager.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 16 : 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPropertyImage(isDesktop),
                const SizedBox(width: 12),
                Expanded(child: _buildContractDetails(isDesktop)),
                const SizedBox(width: 8),
                _buildDownloadButton(isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyImage(bool isDesktop) {
    final size = isDesktop ? 96.0 : 74.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CustomNetworkImage(
        image: widget.contract.propertyImage,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadiusGeometry: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildContractDetails(bool isDesktop) {
    final title = widget.contract.propertyTitle.isNotEmpty
        ? widget.contract.propertyTitle
        : widget.contract.contractName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: isDesktop ? FontSize.s16 : FontSize.s13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            _buildBadge(
              _getOperationLabel(),
              color: _getOperationColor(),
            ),
            if (widget.contract.propertyType.isNotEmpty)
              _buildBadge(widget.contract.propertyType),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _buildSubtitle(),
          style: getMediumStyle(
            color: ColorManager.grey2,
            fontSize: isDesktop ? FontSize.s12 : FontSize.s10,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBadge(String text, {Color? color}) {
    final badgeColor = color ?? ColorManager.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: getMediumStyle(
          color: badgeColor,
          fontSize: FontSize.s10,
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];

    if (widget.contract.area > 0) {
      parts.add('${widget.contract.area.toStringAsFixed(0)} m2');
    }
    if (widget.contract.cityName.isNotEmpty) {
      parts.add(widget.contract.cityName);
    }

    parts.add(DateFormatterService.getFormattedDate(
      widget.contract.dateCreated,
    ));

    return parts.join(' - ');
  }

  Widget _buildDownloadButton(bool isDesktop) {
    final size = isDesktop ? 44.0 : 38.0;

    return Material(
      color: ColorManager.yellowColor.withOpacity(0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: _isDownloading ? null : _handleContractAction,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: _isDownloading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      value: _downloadProgress > 0 ? _downloadProgress : null,
                      strokeWidth: 2,
                      color: ColorManager.primaryColor,
                    ),
                  )
                : SvgImageComponent(
                    color: ColorManager.primaryColor,
                    iconPath: AppAssets.downloadIcon,
                    width: 18,
                    height: 18,
                  ),
          ),
        ),
      ),
    );
  }

  String _getOperationLabel() {
    final operation = widget.contract.operation.toLowerCase();
    if (_isSaleOperation(operation)) return 'Vendu';
    return 'Reservation';
  }

  Color _getOperationColor() {
    final operation = widget.contract.operation.toLowerCase();
    if (_isSaleOperation(operation)) return ColorManager.redColor;
    return ColorManager.greenColor;
  }

  bool _isSaleOperation(String operation) {
    return operation.contains('sale') ||
        operation.contains('sell') ||
        operation == '1';
  }
}
