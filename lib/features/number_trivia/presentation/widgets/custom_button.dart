// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String title;
  const CustomButton({
    Key? key,
    this.backgroundColor,
    required this.title,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          foregroundColor: MaterialStatePropertyAll(textColor),
          textStyle: const MaterialStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
