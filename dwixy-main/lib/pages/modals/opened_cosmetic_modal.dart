import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwixy/bloc/cosmetic_bloc/cosmetic_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:dwixy/reusable%20widgets/date_picker_without_borders.dart';
import 'package:dwixy/reusable%20widgets/drop_down_periodic_widget.dart';
import 'package:dwixy/reusable%20widgets/text_input_invisible_widget.dart';
import 'package:dwixy/reusable%20widgets/white_button_with_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class OpenedCosmeticModal extends StatefulWidget {
  final String id;
  final String type;
  final String name;
  final Timestamp expirationDate;
  final Timestamp openDate;
  final double remains;
  final String periodicOfUse;
  final String size;
  final String imageUrl;

  const OpenedCosmeticModal({
    super.key,
    required this.id,
    required this.type,
    required this.name,
    required this.expirationDate,
    required this.openDate,
    required this.remains,
    required this.periodicOfUse,
    required this.size,
    required this.imageUrl,
  });

  @override
  State<OpenedCosmeticModal> createState() => _OpenedCosmeticModalState();
}

class _OpenedCosmeticModalState extends State<OpenedCosmeticModal> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _peridoOfUseController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _openDateController = TextEditingController();

  late double currentValue;

  Widget buildImage(String url) {
    if (pickedImage != null) {
      return Image.asset(pickedImage!.path);
    } else if (url.isEmpty || !url.startsWith('https://')) {
      return Image.asset('assets/images/empty_image.webp');
    }
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/empty_image.webp');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _typeController.text = widget.type;
    _nameController.text = widget.name;
    _sizeController.text = widget.size;
    _peridoOfUseController.text = widget.periodicOfUse;
    _expirationDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(widget.expirationDate.toDate());
    expirationDate = widget.expirationDate.toDate();
    _openDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(widget.openDate.toDate());
    openDate = widget.openDate.toDate();
    currentValue = widget.remains;
  }

  bool isUploading = false;
  bool isEnabled = false;
  DateTime? expirationDate;
  DateTime? openDate;

  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CosmeticBloc, CosmeticState>(
      listener: (context, state) {
        print('Bloc state: $state');
        if (state is CosmeticError) {
          setState(() => isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is CosmeticSuccess) {
          setState(() => isUploading = false);
          context.read<CosmeticBloc>().add(GetCosmetic());
          if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: Stack(
        children: [
          AlertDialog(
            backgroundColor: AppColors.white,
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (isEnabled == true) {
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            pickedImage = pickedFile;
                          });
                        }
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: buildImage(widget.imageUrl),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextInputInvisibleWidget(
                            multiple: 0.5,
                            controller: _typeController,
                            isEnabled: isEnabled,
                            style: MonseratStyles.montserrat20W700CustomColor(
                              isEnabled ? AppColors.black : AppColors.grey80,
                            ),
                          ),
                          TextInputInvisibleWidget(
                            multiple: 0.5,
                            controller: _nameController,
                            isEnabled: isEnabled,
                            style: MonseratStyles.montserrat14W500CustomColor(
                              isEnabled ? AppColors.grey80 : AppColors.grey50,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEnabled = !isEnabled;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.grey10,
                              padding: EdgeInsets.zero,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/edit.svg',
                              allowDrawingOutsideViewBox: true,
                              colorFilter: ColorFilter.mode(
                                AppColors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/clock.svg',
                        colorFilter: ColorFilter.mode(
                          isEnabled == false
                              ? AppColors.grey80
                              : AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropDownPeriodicWidget(
                          isEnabled: isEnabled,
                          controller: _peridoOfUseController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/calendar.svg',
                        colorFilter: ColorFilter.mode(
                          isEnabled == false
                              ? AppColors.grey80
                              : AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Дата відкриття'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: DatePickerWithoutBordersWidget(
                              textStyle:
                                  isEnabled
                                      ? MonseratStyles.montserrat14W400Black
                                      : MonseratStyles.montserrat14W400Grey80,
                              showSufixIcon: false,
                              hintText: AppTexts.dateOfBirth,
                              function: () async {
                                if (isEnabled == true) {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.utc(2000),
                                        lastDate: DateTime.now(),
                                      );

                                  if (pickedDate != null) {
                                    setState(() {
                                      openDate = pickedDate;
                                      _openDateController.text = DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(pickedDate);
                                    });
                                  }
                                }
                              },
                              textController: _openDateController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/calendar.svg',
                        colorFilter: ColorFilter.mode(
                          isEnabled == false
                              ? AppColors.grey80
                              : AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Термін придатності'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: DatePickerWithoutBordersWidget(
                              textStyle:
                                  isEnabled
                                      ? MonseratStyles.montserrat14W400Black
                                      : MonseratStyles.montserrat14W400Grey80,
                              showSufixIcon: false,
                              hintText: AppTexts.dateOfBirth,
                              function: () async {
                                if (isEnabled == true) {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.utc(2000),
                                        lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month, DateTime.now().day),
                                      );

                                  if (pickedDate != null) {
                                    setState(() {
                                      expirationDate = pickedDate;
                                      _expirationDateController
                                          .text = DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(pickedDate);
                                    });
                                  }
                                }
                              },
                              textController: _expirationDateController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/water.svg',
                        colorFilter: ColorFilter.mode(
                          isEnabled == false
                              ? AppColors.grey80
                              : AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ємність'),
                          TextInputInvisibleWidget(
                            multiple: 0.5,
                            controller: _sizeController,
                            isEnabled: isEnabled,
                            style: MonseratStyles.montserrat14W500CustomColor(
                              isEnabled ? AppColors.grey80 : AppColors.grey50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: AppColors.grey50),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SfSlider(
                      max: 100,
                      min: 0,
                      interval: 25,
                      activeColor: AppColors.pink,
                      inactiveColor: AppColors.grey10,
                      showLabels: true,
                      labelFormatterCallback: (actualValue, formattedText) {
                        return '${actualValue.toInt()}%';
                      },
                      thumbIcon: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        width: 20,
                        height: 20,
                      ),
                      value: currentValue,
                      onChanged: (value) {
                        if (isEnabled == true) {
                          setState(() {
                            currentValue = value;
                          });
                        }
                      },
                    ),
                  ),
                  isEnabled
                      ? SizedBox()
                      : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: BlackButton(
                            buttonText: 'Використав(ла) цей продукт сьогодні',
                            widthMultiplier: 1,
                            buttonFunction: () async {
                              if (currentValue <= 0) {
                              } else if (currentValue > 0) {
                                if (_peridoOfUseController.text ==
                                    "Ранок/Вечір") {
                                  setState(() {
                                    currentValue = math.max(0, currentValue - 1.66);
                                  });
                                  await context.read<CosmeticBloc>()
                                    ..add(
                                      TodayUsedCosmetic(
                                        currentValue,
                                        widget.id,
                                      ),
                                    );
                                  await context.read<CosmeticBloc>()
                                    ..add(GetCosmetic());
                                } else {
                                  setState(() {
                                    currentValue = math.max(0, currentValue - 0.83);
                                  });
                                  await context.read<CosmeticBloc>()
                                    ..add(
                                      TodayUsedCosmetic(
                                        currentValue,
                                        widget.id,
                                      ),
                                    );
                                  await context.read<CosmeticBloc>()
                                    ..add(GetCosmetic());
                                }
                              }
                            },
                            buttonColor: AppColors.black,
                          ),
                        ),
                      ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child:
                        isEnabled
                            ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: BlackButton(
                                buttonFunction: () async {
                                  try {
                                    setState(() => isUploading = true);
                                    context.read<CosmeticBloc>().add(
                                      PutCosmetic(
                                        id: widget.id,
                                        type: _typeController.text,
                                        name: _nameController.text,
                                        size: _sizeController.text,
                                        remains: currentValue,
                                        periodOfUse: _peridoOfUseController.text,
                                        openDate: Timestamp.fromDate(openDate!),
                                        imageUrl: pickedImage != null
                                            ? pickedImage!.path
                                            : widget.imageUrl,
                                        image: pickedImage != null
                                            ? File(pickedImage!.path)
                                            : File(''),
                                        expirationDate: Timestamp.fromDate(
                                          expirationDate!,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    setState(() => isUploading = false);
                                  }
                                },
                                buttonText: 'Зберегти',
                                widthMultiplier: 1,
                                buttonColor: AppColors.black,
                              ),
                            )
                            : SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child:
                          isEnabled
                              ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: WhiteButtonWithBorder(
                                  function: () async {
                                    await context.read<CosmeticBloc>()
                                      ..add(DeleteCosmetic(widget.id, widget.imageUrl));
                                    await context.read<UserBloc>()
                                      ..add(
                                        GetUserData(
                                          uid:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                        ),
                                      );
                                    Navigator.pop(context);
                                  },
                                  buttonText: 'Видалити продукт',
                                ),
                              )
                              : SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUploading)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
