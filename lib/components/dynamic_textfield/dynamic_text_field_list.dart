// lib/components/dynamic_textfield/dynamic_text_field_list.dart

import 'package:flutter/material.dart';

import '../../../../../utils/app_colors/app_colors.dart';

import '../custom_text/custom_text.dart';

import '../snackbar_helper/snackbar_helper.dart';

class DynamicTextFieldList extends StatefulWidget {
  final String fieldLabel;
  final bool isListData;
  final String titleHintText;
  final String descriptionHintText;
  final void Function(Map<String, String>) onDataChanged;
  final Map<String, String> initialValues; // Map type

  final int minFields;
  final String addAnotherLabel;

  final List<int> doubleHeightIndexes;

  const DynamicTextFieldList({
    super.key,

    required this.fieldLabel,
    this.initialValues = const {},
    this.minFields = 1,
    required this.addAnotherLabel,
    this.doubleHeightIndexes = const [],
    required this.titleHintText,
    required this.descriptionHintText,
    this.isListData = false,
    required this.onDataChanged,
  });

  @override
  State<DynamicTextFieldList> createState() => _DynamicTextFieldListState();
}

class _DynamicTextFieldListState extends State<DynamicTextFieldList> {
  late List<TextEditingController> titleControllers;
  late List<TextEditingController> descriptionControllers;
  late List<String> fieldKeys; // Store the keys separately to maintain order

  int counter = 0;

  @override
  void initState() {
    super.initState();

    titleControllers = [];
    descriptionControllers = [];
    fieldKeys = [];

    if (widget.initialValues.isNotEmpty) {
      widget.initialValues.forEach((key, value) {
        titleControllers.add(TextEditingController(text: key));
        descriptionControllers.add(TextEditingController(text: value));
        fieldKeys.add(key);
      });
    } else {
      for (int i = 0; i < widget.minFields; i++) {
        _addNewFieldControllers();
      }
    }
  }

  void _updateData() {
    Map<String, String> data = {};
    for (int i = 0; i < titleControllers.length; i++) {
      if (widget.isListData) {
        // For 'Preparation Steps' and similar single-field lists
        data['Step ${i + 1}'] = titleControllers[i].text;
      } else {
        // For 'Ingredients' and 'Nutrition Info'
        data[titleControllers[i].text] = descriptionControllers[i].text;
      }
    }
    widget.onDataChanged(data);
  }

  void _addNewFieldControllers() {
    counter++;
    String newKey = 'Field $counter';
    titleControllers.add(TextEditingController());
    descriptionControllers.add(TextEditingController());
    fieldKeys.add(newKey);
  }

  void _addField() {
    setState(() {
      _addNewFieldControllers();
    });
  }

  void _removeField(int index) {
    if (fieldKeys.length <= widget.minFields) {
      SnackbarHelper.show(
        message:
            'Keep at least ${widget.minFields} ${widget.fieldLabel.toLowerCase()}${widget.minFields > 1 ? 's' : ''}.',
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
        isSuccess: false,
      );
      return;
    }

    setState(() {
      titleControllers[index].dispose();
      descriptionControllers[index].dispose();
      titleControllers.removeAt(index);
      descriptionControllers.removeAt(index);
      fieldKeys.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in titleControllers) {
      controller.dispose();
    }

    for (var controller in descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        ...List.generate(fieldKeys.length, (index) {
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    textAlign: TextAlign.start,
                    text:
                        fieldKeys.length > 1
                            ? '${widget.fieldLabel} ${index + 1}'
                            : widget.fieldLabel,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: titleControllers[index],
                          onChanged: (text) => _updateData(),
                          decoration: InputDecoration(
                            hintText: widget.titleHintText,
                            hintStyle: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 12,
                            ),
                            border: const UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // If not preparation step, show the description field as well
                      if (widget.isListData == false)
                        Expanded(
                          child: TextField(
                            controller: descriptionControllers[index],
                            onChanged: (text) => _updateData(),
                            decoration: InputDecoration(
                              hintText: widget.descriptionHintText,
                              hintStyle: TextStyle(
                                color: AppColors.mediumGray,
                                fontSize: 12,
                              ),
                              border: const UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      SizedBox(width: 8),
                      if (fieldKeys.length > widget.minFields)
                        GestureDetector(
                          onTap: () => _removeField(index),
                          child: Icon(
                            Icons.delete,
                            size: 24,
                            color: AppColors.black,
                          ),
                        ),
                      SizedBox(width: 4),
                      if (index == fieldKeys.length - 1)
                        GestureDetector(
                          onTap: _addField,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.mediumGray),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (index < fieldKeys.length - 1)
                Divider(color: AppColors.borderGray, height: 8, thickness: 1),
            ],
          );
        }),
      ],
    );
  }
}
