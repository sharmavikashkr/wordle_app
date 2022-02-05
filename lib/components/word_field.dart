import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordTextField extends StatefulWidget {
  /// If the word enabled to take input
  final bool enabled;

  /// Number of the Word Fields
  final int length;

  /// Total Width of the Word Text Field
  final double width;

  /// Width of the single Word Field
  final double fieldWidth;

  /// Manage the type of keyboard that shows up
  TextInputType keyboardType;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  // character colors
  final String colors;

  /// Callback function, called when a change is detected to the word.
  final ValueChanged<String> onChanged;

  /// Callback function, called when word is completed.
  final ValueChanged<String> onCompleted;

  final int attempts;

  WordTextField(
      {Key key,
      this.enabled = false,
      this.length = 5,
      this.width = 50,
      this.fieldWidth = 60,
      this.keyboardType = TextInputType.text,
      this.textFieldAlignment = MainAxisAlignment.spaceBetween,
      this.obscureText = false,
      this.colors = 'wwwww',
      this.onChanged,
      this.onCompleted,
      this.attempts})
      : assert(length > 1);

  @override
  _WordTextFieldState createState() => _WordTextFieldState();
}

class _WordTextFieldState extends State<WordTextField> {
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  List<Widget> _textFields;
  List<String> _word;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>(widget.length);
    _textControllers = List<TextEditingController>(widget.length);
    _word = List.generate(widget.length, (int i) {
      return '';
    });
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _textFields = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      _textFields.add(buildTextField(context, i));
    }
    return Container(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _textFields,
      ),
    );
  }

  Widget buildTextField(BuildContext context, int i) {
    if (_focusNodes[i] == null) _focusNodes[i] = new FocusNode();
    if (_textControllers[i] == null) _textControllers[i] = new TextEditingController();
    return Card(
      color: widget.colors[i] == 'w'
          ? Colors.white
          : widget.colors[i] == 'b'
              ? const Color(0xFF787C7E)
              : widget.colors[i] == 'y'
                  ? const Color(0xFFC9B458)
                  : const Color(0xFF6AAA64),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          width: widget.colors[i] == 'w' ? 0.5 : 0,
          color: const Color(0xFFD3d6DA),
        ),
      ),
      child: SizedBox(
        width: widget.fieldWidth,
        height: widget.fieldWidth,
        child: TextField(
          enabled: widget.enabled,
          controller: _textControllers[i],
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: widget.enabled ? Colors.black : Colors.white,
          ),
          focusNode: _focusNodes[i],
          obscureText: widget.obscureText,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              fontSize: 40,
              color: Colors.black,
            ),
            border: InputBorder.none,
            counterText: "",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (String str) {
            if (str.isEmpty) {
              if (i == 0) return;
              _focusNodes[i].unfocus();
              _focusNodes[i - 1].requestFocus();
            }
            // Update the current word
            setState(() {
              _word[i] = str;
            });
            // Remove focus
            if (str.isNotEmpty) _focusNodes[i].unfocus();
            // Set focus to the next field if available
            if (i + 1 != widget.length && str.isNotEmpty) FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            String currentWord = "";
            _word.forEach((String value) {
              currentWord += value;
            });
            // Call the `onCompleted` callback on last input
            if (!_word.contains(null) && !_word.contains('') && currentWord.length == widget.length) {
              widget.onCompleted(currentWord);
            }
            // Call the `onChanged` callback function
            widget.onChanged(currentWord);
          },
        ),
      ),
    );
  }
}
