import 'package:dwixy/consts/colors.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double widthMultiplier;

  const CustomProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.widthMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: MediaQuery.of(context).size.width * widthMultiplier,
            height: 10,
            decoration: BoxDecoration(
              color: index < currentStep ? AppColors.pink : AppColors.grey50,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }
}
