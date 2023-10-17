import 'package:flutter/material.dart';

class RenderTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;

  const RenderTextField({
    required this.label,
    required this.onSaved,
    required this.validator,
    required this.textInputAction,
    required this.textEditingController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          controller: textEditingController,
          decoration: InputDecoration(
            label: Text('${label}'),
            labelStyle: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontSize: 23.0,
            ),
          ),
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
