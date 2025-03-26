import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:camera/camera.dart' show CameraDescription;

// ignore: must_be_immutable
import '../misc/constants.dart';
import 'extensions/crop_image.dart';
import 'extensions/custom_material_button.dart';
import 'extensions/get_visible_portion.dart';
import 'helpers/mask_for_camera_view_border_type.dart';
import 'helpers/view_style.dart';
import 'inside_line/mask_for_camera_view_inside_line.dart';
import 'mask_for_camera_view_result.dart';
export 'package:camera/camera.dart' show CameraDescription;

// ignore: must_be_immutable
class MaskForCameraView extends StatefulWidget {
  const MaskForCameraView({
    Key? key,
    this.title = "Take Photo of Your ID",
    this.subTitle =
        "Please make sure there’s enough lighting and that the ID lettering is clear before continuing.",
    this.boxWidth = 300.0,
    this.boxHeight = 240.0,
    this.boxBorderWidth = 1.8,
    this.boxBorderRadius = 3.2,
    required this.cameraDescription,
    required this.onTake,
    this.borderType = MaskForCameraViewBorderType.dotted,
    this.insideLine,
    this.visiblePopButton = true,
    this.viewStyle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  /// Give in Image pixels.Box width will be converted based on device ratio. (Cropped image will apear in this size.)
  final double boxWidth;

  /// Give in Image pixels.Box height will be converted based on device ratio. (Cropped image will apear in this size.)
  final double boxHeight;
  final double boxBorderWidth;
  final double boxBorderRadius;
  final bool visiblePopButton;
  final CameraDescription cameraDescription;
  final MaskForCameraViewInsideLine? insideLine;
  final MaskForCameraViewStyle? viewStyle;
  final ValueSetter<MaskForCameraViewResult?> onTake;
  final MaskForCameraViewBorderType borderType;
  @override
  State<StatefulWidget> createState() => _MaskForCameraViewState();

  static Future<List<CameraDescription>> initialize() async {
    return await availableCameras();
  }
}

class _MaskForCameraViewState extends State<MaskForCameraView> {
  bool isRunning = false;
  int cameraRotation = 0;

  late CameraController cameraController;
  GlobalKey boxKey = GlobalKey();

  FlashMode _flashMode = FlashMode.off;
  late MaskForCameraViewStyle styles;

  @override
  void initState() {
    styles = widget.viewStyle ?? MaskForCameraViewStyle();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    cameraController = CameraController(
      widget.cameraDescription,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    cameraController.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    cameraController.lockCaptureOrientation();

    super.initState();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraController.initialize();
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            bottom: 0.0,
            right: 0.0,
            child: !cameraController.value.isInitialized
                ? Container()
                : ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CameraPreview(cameraController),
                        ),
                      ),
                    ),
                  ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              decoration: BoxDecoration(
                color: styles.appBarColor,
                //color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                    // bottomLeft: Radius.circular(16.0),
                    // bottomRight: Radius.circular(16.0),
                    ),
              ),
              child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.visiblePopButton
                              ? _IconButton(
                                  Icons.arrow_back_ios_rounded,
                                  color: styles.iconsColor,
                                  onTap: () => Navigator.pop(context),
                                )
                              : Container(),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: styles.titleStyle,
                            ),
                          ),
                          _IconButton(
                            _flashMode == FlashMode.auto
                                ? Icons.flash_auto_outlined
                                : _flashMode == FlashMode.torch
                                    ? Icons.flash_on_outlined
                                    : Icons.flash_off_outlined,
                            color: styles.iconsColor,
                            onTap: () => setState(() {
                              if (_flashMode == FlashMode.auto) {
                                cameraController.setFlashMode(FlashMode.torch);
                                _flashMode = FlashMode.torch;
                              } else if (_flashMode == FlashMode.torch) {
                                cameraController.setFlashMode(FlashMode.off);
                                _flashMode = FlashMode.off;
                              } else {
                                cameraController.setFlashMode(FlashMode.auto);
                                _flashMode = FlashMode.auto;
                              }
                            }),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Text(widget.subTitle,
                            style:
                                interText(16, Colors.white, FontWeight.w500)),
                      )
                    ],
                  )),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: widget.viewStyle?.appBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomMaterialButton(
                        width: MediaQuery.sizeOf(context).width * .9,
                        label: 'Take Photo',
                        buttonColor: Colors.green,
                        fontColor: Colors.white,
                        funcName: () async {
                          if (isRunning) {
                            return;
                          }
                          setState(() {
                            isRunning = true;
                          });

                          XFile xFile = await cameraController.takePicture();

                          await cameraController.pausePreview();

                          MaskForCameraViewResult? res = await _cropPicture(
                            File(xFile.path),
                            screenSize: MediaQuery.of(context).size,
                            insideLine: widget.insideLine,
                            desiredSize:
                                Size(widget.boxWidth, widget.boxHeight),
                          );

                          widget.onTake(res);

                          await cameraController.resumePreview();
                          setState(() {
                            isRunning = false;
                          });
                        },
                        borderRadius: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 38.0, bottom: 38, left: 38, right: 38),
                child: AspectRatio(
                  aspectRatio:
                      Size(widget.boxWidth, widget.boxHeight).aspectRatio,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    strokeWidth:
                        widget.borderType == MaskForCameraViewBorderType.dotted
                            ? widget.boxBorderWidth
                            : 0.0,
                    color:
                        widget.borderType == MaskForCameraViewBorderType.dotted
                            ? styles.boxBorderColor
                            : Colors.transparent,
                    dashPattern: const [4, 3],
                    radius: Radius.circular(
                      widget.boxBorderRadius,
                    ),
                    child: Container(
                      key: boxKey,
                      decoration: BoxDecoration(
                        color: isRunning ? Colors.white60 : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(widget.boxBorderRadius),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: widget.borderType ==
                                    MaskForCameraViewBorderType.solid
                                ? widget.boxBorderWidth
                                : 0.0,
                            color: widget.borderType ==
                                    MaskForCameraViewBorderType.solid
                                ? styles.boxBorderColor
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(
                            widget.boxBorderRadius,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: widget.insideLine != null &&
                                          widget.insideLine!.direction ==
                                              null ||
                                      widget.insideLine != null &&
                                          widget.insideLine!.direction ==
                                              MaskForCameraViewInsideLineDirection
                                                  .horizontal
                                  ? ((widget.boxHeight / 10) *
                                      _position(widget.insideLine!.position))
                                  : 0.0,
                              left: widget.insideLine != null &&
                                      widget.insideLine!.direction ==
                                          MaskForCameraViewInsideLineDirection
                                              .vertical
                                  ? ((widget.boxWidth / 10) *
                                      _position(widget.insideLine!.position))
                                  : 0.0,
                              child: widget.insideLine != null
                                  ? _Line(
                                      widget,
                                      boxBorderColor: styles.boxBorderColor,
                                    )
                                  : Container(),
                            ),
                            Positioned(
                              child: _IsCropping(
                                  isRunning: isRunning, widget: widget),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<MaskForCameraViewResult?> _cropPicture(File imageFile,
      {required Size screenSize,
      MaskForCameraViewInsideLine? insideLine,
      required Size desiredSize}) async {
    RenderBox box = boxKey.currentContext!.findRenderObject() as RenderBox;

    final image =
        await getVisiblePortion(imageFile, flutterScreenSize: screenSize);

    if (image == null) {
      return null;
    }

    // Adjustments here to move the cropping box up by 50 pixels
    final double flutterX = box.localToGlobal(Offset.zero).dx;
    final double flutterY = box.localToGlobal(Offset(0, -50)).dy;

    // Additional print statements for debugging
    print('Flutter X: $flutterX, Flutter Y: $flutterY');
    print(
        'Box Width: ${box.paintBounds.width}, Box Height: ${box.paintBounds.height}');

    final ui.Rect flutterBoxRect = ui.Rect.fromLTWH(
        flutterX, flutterY, box.paintBounds.width, box.paintBounds.height);

    MaskForCameraViewResult result = await cropImage(
      image,
      flutterBoxRect: flutterBoxRect,
      insideLine: insideLine,
      desiredSize: desiredSize,
    );
    return result;
  }
}

// IconButton
class _IconButton extends StatelessWidget {
  const _IconButton(this.icon,
      {Key? key, required this.color, required this.onTap})
      : super(key: key);
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22.0),
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}

// Line inside box
class _Line extends StatelessWidget {
  const _Line(this.widget, {required this.boxBorderColor, Key? key})
      : super(key: key);
  final MaskForCameraView widget;
  final Color boxBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.insideLine!.direction == null ||
              widget.insideLine!.direction ==
                  MaskForCameraViewInsideLineDirection.horizontal
          ? widget.boxWidth
          : widget.boxBorderWidth,
      height: widget.insideLine!.direction != null &&
              widget.insideLine!.direction ==
                  MaskForCameraViewInsideLineDirection.vertical
          ? widget.boxHeight
          : widget.boxBorderWidth,
      color: boxBorderColor,
    );
  }
}

// Progress widget. Used during cropping.
class _IsCropping extends StatelessWidget {
  const _IsCropping({Key? key, required this.isRunning, required this.widget})
      : super(key: key);
  final bool isRunning;
  final MaskForCameraView widget;

  @override
  Widget build(BuildContext context) {
    return isRunning && widget.boxWidth >= 50.0 && widget.boxHeight >= 50.0
        ? const Center(
            child: CupertinoActivityIndicator(
              radius: 12.8,
            ),
          )
        : Container();
  }
}

// To get position index for crop
int _position(MaskForCameraViewInsideLinePosition? position) {
  int p = 5;
  if (position != null) {
    p = position.index + 1;
  }
  return p;
}
