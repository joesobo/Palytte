import 'package:colorite/utilities/constants.dart';
import 'package:flutter/material.dart';

enum Mode { rgb, hsv }

Mode mode = Mode.rgb;

class SelectorCard extends StatefulWidget {
  final int r = 125;
  final int g = 125;
  final int b = 125;
  final int h = 180;
  final int s = 50;
  final int v = 50;

  final Color mainColor = Colors.white;

  @override
  _SelectorCardState createState() => _SelectorCardState(
      r: r, g: g, b: b, h: h, s: s, v: v, mainColor: mainColor);
}

class _SelectorCardState extends State<SelectorCard> {
  int r;
  int g;
  int b;
  int h;
  int s;
  int v;
  Color mainColor;

  String hexText = '';

  _SelectorCardState(
      {this.r, this.g, this.b, this.h, this.s, this.v, this.mainColor});

  @override
  void initState() {
    mainColor = Color.fromRGBO(r, g, b, 1);
    hexText = 'Hex: #${mainColor.value.toRadixString(16).toUpperCase()}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text(
        'Edit your main color',
        textAlign: TextAlign.center,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //hex text, color indicator, and mode selector
          Column(
            children: <Widget>[
              //hex text
              Text(hexText, style: TextStyle(color: Colors.grey)),
              //color indicator
              mode == Mode.rgb
                  ? ColorIndicator(color: Color.fromRGBO(r, g, b, 1))
                  : ColorIndicator(
                      color:
                          HSVColor.fromAHSV(1, h.toDouble(), s / 100, v / 100)
                              .toColor()),
              //mode selector
              ModeSelector(parent: this),
            ],
          ),
          //color selection sliders
          mode == Mode.rgb ? rgbSliders() : hsvSliders(),
          //submit button
          RaisedButton(
            color: Colors.blueGrey,
            elevation: 5,
            splashColor: Colors.blueGrey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Save',
              style: defaultText,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //creates 3 sliders for rgb
  Widget rgbSliders() {
    return Column(
      children: <Widget>[
        ColorSlider(
          parent: this,
          text: 'Red',
          value: r,
          activeColor: Colors.red,
          overlayColor: Color(0x5fe57373),
          max: 255,
        ),
        ColorSlider(
          parent: this,
          text: 'Green',
          value: g,
          activeColor: Colors.green,
          overlayColor: Color(0x5f81c784),
          max: 255,
        ),
        ColorSlider(
          parent: this,
          text: 'Blue',
          value: b,
          activeColor: Colors.blue,
          overlayColor: Color(0x5f03A9f4),
          max: 255,
        ),
      ],
    );
  }

  //creates 3 sliders for hsv
  Widget hsvSliders() {
    return Column(
      children: <Widget>[
        ColorSlider(
          parent: this,
          text: 'Hue',
          value: h.toInt(),
          activeColor: Colors.lightBlueAccent,
          overlayColor: Color(0x5f4fc3f7),
          max: 360,
        ),
        ColorSlider(
          parent: this,
          text: 'Saturation',
          value: s.toInt(),
          activeColor: Colors.white,
          overlayColor: Color(0x5fffffff),
          max: 100,
        ),
        ColorSlider(
          parent: this,
          text: 'Value',
          value: v.toInt(),
          activeColor: Colors.black,
          overlayColor: Color(0x5f000000),
          max: 100,
        ),
      ],
    );
  }
}

//display color
class ColorIndicator extends StatelessWidget {
  final Color color;

  ColorIndicator({this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16),
      height: 104,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
    );
  }
}

//switches between rgb and hsv
class ModeSelector extends StatelessWidget {
  final _SelectorCardState parent;

  ModeSelector({@required this.parent});

  @override
  Widget build(BuildContext context) {
    //creates row for selected color mode
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //RGB outline vs filled
        mode == Mode.rgb
            ? filled('RGB', Mode.rgb)
            : outline('RGB', () {
                parent.setState(() {
                  mode = Mode.rgb;
                  Color color = parent.mainColor;
                  parent.r = color.red;
                  parent.g = color.green;
                  parent.b = color.blue;
                });
              }, Mode.rgb),
        //HSV outline vs filled
        mode == Mode.hsv
            ? filled('HSV', Mode.hsv)
            : outline('HSV', () {
                parent.setState(() {
                  mode = Mode.hsv;
                  HSVColor color = HSVColor.fromColor(parent.mainColor);
                  parent.h = color.hue.toInt();
                  parent.s = (color.saturation * 100).toInt();
                  parent.v = (color.value * 100).toInt();
                });
              }, Mode.hsv),
      ],
    );
  }

  //returns outline button of mode selector
  OutlineButton outline(String text, Function onPressed, Mode mode) {
    return OutlineButton(
      highlightedBorderColor: Colors.grey,
      borderSide: BorderSide(color: Colors.grey),
      child: Text(text),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: mode == Mode.rgb ? Radius.circular(5) : Radius.zero,
          bottomLeft: mode == Mode.rgb ? Radius.circular(5) : Radius.zero,
          topRight: mode == Mode.hsv ? Radius.circular(5) : Radius.zero,
          bottomRight: mode == Mode.hsv ? Radius.circular(5) : Radius.zero,
        ),
      ),
    );
  }

  //returns filled button of mode selector
  FlatButton filled(String text, Mode mode) {
    return FlatButton(
      color: Colors.grey,
      child: Text(text),
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: mode == Mode.rgb ? Radius.circular(5) : Radius.zero,
          bottomLeft: mode == Mode.rgb ? Radius.circular(5) : Radius.zero,
          topRight: mode == Mode.hsv ? Radius.circular(5) : Radius.zero,
          bottomRight: mode == Mode.hsv ? Radius.circular(5) : Radius.zero,
        ),
      ),
    );
  }
}

//creates a color slider based on mode
class ColorSlider extends StatelessWidget {
  final _SelectorCardState parent;
  final String text;
  final int value;
  final Color activeColor;
  final Color overlayColor;
  final double max;

  ColorSlider({
    @required this.parent,
    this.text,
    this.value,
    this.activeColor,
    this.overlayColor,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(text),
              (text == 'Saturation' || text == 'Value')
                  ? Text(value.toString() + "%")
                  : Text(value.toString())
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
              thumbColor: Colors.white,
              activeTrackColor: activeColor,
              overlayColor: overlayColor,
            ),
            child: Slider(
              min: 0,
              max: max,
              value: value.toDouble(),
              onChanged: (double newValue) {
                parent.setState(() {
                  if (text == 'Red' || text == 'Blue' || text == 'Green') {
                    parent.hexText =
                        'Hex: #${Color.fromRGBO(parent.r, parent.g, parent.b, 1).value.toRadixString(16).toUpperCase()}';
                    parent.mainColor =
                        Color.fromRGBO(parent.r, parent.g, parent.b, 1);

                    if (text == 'Red') {
                      parent.r = newValue.round();
                    } else if (text == 'Blue') {
                      parent.b = newValue.round();
                    } else if (text == 'Green') {
                      parent.g = newValue.round();
                    }
                  } else if (text == 'Hue' ||
                      text == 'Saturation' ||
                      text == 'Value') {
                    parent.hexText =
                        'Hex: #${HSVColor.fromAHSV(1, parent.h.toDouble(), parent.s / 100, parent.v / 100).toColor().value.toRadixString(16).toUpperCase()}';
                    parent.mainColor = HSVColor.fromAHSV(1, parent.h.toDouble(),
                            parent.s / 100, parent.v / 100)
                        .toColor();

                    if (text == 'Hue') {
                      parent.h = newValue.round();
                    } else if (text == 'Saturation') {
                      parent.s = newValue.round();
                    } else if (text == 'Value') {
                      parent.v = newValue.round();
                    }
                  }
                });
              },
            ),
          ),
          Container(
            height: 1,
            width: 225,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
