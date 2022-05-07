import 'package:flutter/material.dart';
import 'package:cupertino_range_slider/cupertino_range_slider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cupertino Range Slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Range Slider Demo'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            RangeSliderItem(
              title: 'Happiness',
              initialMinValue: 20,
              initialMaxValue: 80,
              onMinValueChanged: (v){},
              onMaxValueChanged: (v){},
            ),
            RangeSliderItem(
              title: 'Kindness',
              initialMinValue: 55,
              initialMaxValue: 89,
              onMinValueChanged: (v){},
              onMaxValueChanged: (v){},
            ),
            RangeSliderItem(
              title: 'Humor',
              initialMinValue: 40,
              initialMaxValue: 60,
              onMinValueChanged: (v){},
              onMaxValueChanged: (v){},
            ),
            RangeSliderItem(
              title: 'Angerness',
              initialMinValue: 10,
              initialMaxValue: 30,
              onMinValueChanged: (v){},
              onMaxValueChanged: (v){},
            ),
          ],
        ),
      ),
    );
  }
}



class RangeSliderItem extends StatefulWidget {
  final String title;
  final int initialMinValue;
  final int initialMaxValue;
  final ValueChanged<int>? onMinValueChanged;
  final ValueChanged<int>? onMaxValueChanged;

  const RangeSliderItem({Key? key, required this.title, required this.initialMinValue, required this.initialMaxValue, this.onMinValueChanged, this.onMaxValueChanged}) : super(key: key);

  @override
  _RangeSliderItemState createState() => _RangeSliderItemState();
}

class _RangeSliderItemState extends State<RangeSliderItem> {
  late int minValue;
  late int maxValue;


  @override
  void initState() {
    super.initState();
    minValue = widget.initialMinValue;
    maxValue = widget.initialMaxValue;
  }

  @override
  Widget build(BuildContext context) {
    return FilterItemHolder(
      title: widget.title,
      value: '$minValue-$maxValue',
      child: CupertinoRangeSlider(
        minValue: minValue.roundToDouble(),
        maxValue: maxValue.roundToDouble(),
        min: 1.0,
        max: 100.0,
        onMinChanged: (minVal){
          setState(() {
            minValue = minVal.round();
            widget.onMinValueChanged?.call(minValue);
          });
        },
        onMaxChanged: (maxVal){
          setState(() {
            maxValue = maxVal.round();
            widget.onMaxValueChanged?.call(maxValue);
          });
        },
      ),
    );
  }
}



///
///
///
class FilterItemHolder extends StatelessWidget {
  final String title;
  final String value;
  final Widget child;

  const FilterItemHolder({Key? key, required this.title, this.value = '', required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: titleTextStyle,
                ),
              ),
              Text(
                value,
                style: titleTextStyle,
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Container(
            height: 47.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: child,
            ),
          ),
        )
      ],
    );
  }

  final titleTextStyle = const TextStyle(
    color: Color(0xFF000000),
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
  );
}
