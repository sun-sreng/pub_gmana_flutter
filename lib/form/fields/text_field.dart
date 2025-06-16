import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/field_config.dart';
import 'base_field.dart';

/// A customizable text input field.
class GTextField extends GBaseField {
  GTextField({
    super.key,
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    IconData? prefixIcon,
  }) : super(
         config: GFieldConfig(
           controller: controller,
           labelText: labelText,
           hintText: hintText ?? '',
           keyboardType: TextInputType.text,
           textInputAction: textInputAction ?? TextInputAction.next,
           inputFormatters: inputFormatters,
           validator: validator,
           onChanged: onChanged,
           prefixIcon: prefixIcon ?? Icons.text_fields,
         ),
       );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: config.controller,
      keyboardType: config.keyboardType,
      textInputAction: config.textInputAction,
      inputFormatters: config.inputFormatters,
      validator: config.validator,
      onChanged: config.onChanged,
      decoration: InputDecoration(
        labelText: config.labelText,
        hintText: config.hintText,
        prefixIcon: Icon(config.prefixIcon),
      ),
    );
  }
}
