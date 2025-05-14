import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwixy/bloc/cosmetic_bloc/cosmetic_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/roboto_styles.dart';
import 'package:dwixy/models/cosmetic_model.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:dwixy/reusable%20widgets/date_picker_widget.dart';
import 'package:dwixy/reusable%20widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AddNewCosmeticModal extends StatefulWidget {
  const AddNewCosmeticModal({super.key});

  @override
  _AddNewCosmeticModalState createState() => _AddNewCosmeticModalState();
}

class _AddNewCosmeticModalState extends State<AddNewCosmeticModal> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _openDateController = TextEditingController();
  final TextEditingController _periodOfUseController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  XFile? pickedImage;

  final List<String> _listPeriodOfUse = <String>[
    'Ранок',
    'Вечір',
    'Обід',
    'Ранок/Вечір',
  ];

  String? dropDownValue;
  DateTime? selectedExpirationDate;
  DateTime? selectedOpenDate;

  @override
  void initState() {
    super.initState();
    dropDownValue = _listPeriodOfUse.first;
    _typeController.addListener(checkTextField);
    _sizeController.addListener(checkTextField);
    _expirationDateController.addListener(checkTextField);
    _openDateController.addListener(checkTextField);
    _imageUrlController.addListener(checkTextField);
    _periodOfUseController.text = _listPeriodOfUse.first;
    _nameController.addListener(checkTextField);
  }

  bool isButtonEnabled = false;
  bool isUploading = false;

  double _currentSliderValue = 100;

  void checkTextField() {
    setState(() {
      isButtonEnabled =
          _nameController.text.isNotEmpty &&
          _sizeController.text.isNotEmpty &&
          _periodOfUseController.text.isNotEmpty &&
          pickedImage != null &&
          pickedImage!.path.isNotEmpty &&
          _expirationDateController.text.isNotEmpty &&
          _openDateController.text.isNotEmpty;
    });
  }

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
            backgroundColor: AppColors.pinkLight,
            content: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              pickedImage = pickedFile;
                            });
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: pickedImage == null
                              ? Image.asset('assets/images/no_image.png')
                              : Image.file(File(pickedImage!.path), height: 180),
                        ),
                      ),
                    ),
                    Text('Назва продукту', style: RobotoStyles.roboto16W500Black),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFieldWidget(
                        controller: _typeController,
                        hintText: 'Сироватка, Крем, Тонік',
                      ),
                    ),
                    Text(
                      'Бренд або повна назва',
                      style: RobotoStyles.roboto16W500Black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFieldWidget(
                        controller: _nameController,
                        hintText: "The Ordinary - Hyaluronic Acid 2% + B5",
                      ),
                    ),
                    Text("Об'єм", style: RobotoStyles.roboto16W500Black),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: _sizeController,
                        style: MonseratStyles.montserrat14W400Black,
                        autovalidateMode: AutovalidateMode.always,
                        decoration: InputDecoration(
                          hintText: '30 мл, 50г',
                          hintStyle: MonseratStyles.montserrat14W400Grey50,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey30, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey30, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey30, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey30, width: 1),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Частота використання",
                      style: RobotoStyles.roboto16W500Black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownMenu<String>(
                        width: MediaQuery.of(context).size.width,
                        textStyle: MonseratStyles.montserrat14W400Black,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey50, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey50, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey50, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            AppColors.pinkLight,
                          ),
                          side: WidgetStateProperty.all(
                            BorderSide(color: AppColors.grey50, width: 1),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        initialSelection: dropDownValue,
                        onSelected: (String? value) {
                          setState(() {
                            dropDownValue = value;
                            _periodOfUseController.text = value!;
                          });
                        },
                        dropdownMenuEntries:
                            _listPeriodOfUse
                                .map(
                                  (value) => DropdownMenuEntry<String>(
                                    value: value,
                                    label: value,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    Text('Доки вжито', style: RobotoStyles.roboto16W500Black),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DatePickerWidget(
                        showSufixIcon: false,
                        hintText: 'Вжите до',
                        function: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.utc(1900),
                            lastDate: DateTime.now().add(Duration(days: 2000)),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedExpirationDate = pickedDate;
                              _expirationDateController.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(pickedDate);
                            });
                          }
                        },
                        textController: _expirationDateController,
                      ),
                    ),
                    Text('Дата відкриття', style: RobotoStyles.roboto16W500Black),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DatePickerWidget(
                        showSufixIcon: false,
                        hintText: 'Дата відкриття',
                        function: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.utc(1900),
                            lastDate: DateTime.now().add(Duration(days: 2000)),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedOpenDate = pickedDate;
                              _openDateController.text = DateFormat(
                                'dd/MM/yyyy',
                              ).format(pickedDate);
                            });
                          }
                        },
                        textController: _openDateController,
                      ),
                    ),
                    Text(
                      'Залишилось продукту',
                      style: MonseratStyles.montserrat14W500Grey80,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SfSlider(
                        max: 100,
                        min: 0,
                        interval: 25,
                        activeColor: AppColors.pink,
                        inactiveColor: AppColors.grey10,
                        thumbIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          width: 20,
                          height: 20,
                        ),
                        showLabels: true,
                        labelFormatterCallback: (actualValue, formattedText) {
                          return '${actualValue.toInt()}%';
                        },
                        value: _currentSliderValue,
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: BlackButton(
                        buttonText: "Добавити продукт",
                        widthMultiplier: 1,
                        buttonColor:
                            isButtonEnabled ? AppColors.black : AppColors.grey50,
                        buttonFunction: () {
                          if (isButtonEnabled) {
                            setState(() => isUploading = true);
                            context.read<CosmeticBloc>().add(
                              PushCosmetic(
                                type: _typeController.text,
                                name: _nameController.text,
                                size: _sizeController.text,
                                expirationDate: Timestamp.fromDate(selectedExpirationDate!),
                                openDate: Timestamp.now(),
                                remains: _currentSliderValue,
                                periodOfUse: _periodOfUseController.text,
                                imageUrl: pickedImage?.path ?? '',
                                image: pickedImage != null
                                    ? File(pickedImage!.path)
                                    : File(''),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
