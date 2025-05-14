import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final Map<String, dynamic> selectedAnswers;
  final bool isMultiSelect;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.selectedAnswers,
    required this.isMultiSelect,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question, style: MonseratStyles.montserrat16W600Black),
        const SizedBox(height: 8),
        ...widget.options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: ListTile(
              selected:
                  widget.isMultiSelect
                      ? (widget.selectedAnswers[widget.question]
                                  as List<String>?)
                              ?.contains(option) ??
                          false
                      : widget.selectedAnswers[widget.question] == option,
              selectedTileColor: AppColors.pink2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  width:
                      widget.isMultiSelect
                          ? ((widget.selectedAnswers[widget.question]
                                          as List<String>?)
                                      ?.contains(option) ??
                                  false)
                              ? 2
                              : 1
                          : (widget.selectedAnswers[widget.question] == option
                              ? 2
                              : 1),
                  color:
                      widget.isMultiSelect
                          ? ((widget.selectedAnswers[widget.question]
                                          as List<String>?)
                                      ?.contains(option) ??
                                  false)
                              ? AppColors.pink3
                              : AppColors.grey30
                          : (widget.selectedAnswers[widget.question] == option
                              ? AppColors.pink3
                              : AppColors.grey30),
                ),
              ),
              trailing: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  checkColor: AppColors.white,
                  activeColor: AppColors.pink3,
                  side: WidgetStateBorderSide.resolveWith((
                    Set<WidgetState> states,
                  ) {
                    return BorderSide(
                      color:
                          widget.isMultiSelect
                              ? ((widget.selectedAnswers[widget.question]
                                              as List<String>?)
                                          ?.contains(option) ??
                                      false)
                                  ? AppColors.pink3
                                  : Colors.transparent
                              : (widget.selectedAnswers[widget.question] ==
                                      option
                                  ? AppColors.pink3
                                  : Colors.transparent),
                      width: 2,
                    );
                  }),
                  value:
                      widget.isMultiSelect
                          ? (widget.selectedAnswers[widget.question]
                                      as List<String>?)
                                  ?.contains(option) ??
                              false
                          : widget.selectedAnswers[widget.question] == option,
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (widget.isMultiSelect) {
                        final currentList =
                            (widget.selectedAnswers[widget.question]
                                as List<String>?) ??
                            [];
                        if (currentList.contains(option)) {
                          currentList.remove(option);
                        } else {
                          currentList.add(option);
                        }
                        widget.selectedAnswers[widget.question] = currentList;
                      } else {
                        widget.selectedAnswers[widget.question] = option;
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
              ),
              title: Text(option),
              onTap: () {
                setState(() {
                  if (widget.isMultiSelect) {
                    final currentList =
                        (widget.selectedAnswers[widget.question]
                            as List<String>?) ??
                        [];
                    if (currentList.contains(option)) {
                      currentList.remove(option);
                    } else {
                      currentList.add(option);
                    }
                    widget.selectedAnswers[widget.question] = currentList;
                  } else {
                    widget.selectedAnswers[widget.question] = option;
                  }
                });
              },
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}
