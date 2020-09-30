import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grade Calculator",
      home: Scaffold(
        appBar: AppBar(title: Text("Grade Calculator")),
        body: Center(
            child: Container(
          constraints: BoxConstraints(maxWidth: 275),
          padding: EdgeInsets.all(20),
          child: GenerateGrade(),
        )),
      ),
    );
  }
}

class Grade {
  bool _display;
  double _score;
  double _possiblePoints;
  String _grade;

  Grade() {
    _display = false;
    _grade = "";
  }
}

class GenerateGrade extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GenerateGradeState();
}

class _GenerateGradeState extends State<GenerateGrade> {
  final _formKey = GlobalKey<FormState>();
  Grade grade = new Grade();
  var _scoreInput;
  var _possiblePointsInput;
  String _dropdown = "Standard";

  void _onSubmit() {
    setState(() {
      this.grade._display = true;
      if (this._dropdown == "Standard") {
        print("Standard grading");
        this.grade._grade = _calculateStandardGrade(
            this.grade._score, this.grade._possiblePoints);
      }
      if (this._dropdown == "Triage") {
        print("Triage grading");
        this.grade._grade = _calculateTriageGrade(
            this.grade._score, this.grade._possiblePoints);
      }
    });
  }

  String _calculateStandardGrade(double score, double possiblePoints) {
    double percent = (score / possiblePoints) * 100;
    if (percent >= 90) return "A";
    if (percent >= 80) return "B";
    if (percent >= 70) return "C";
    if (percent >= 60) return "D";
    if (percent < 60) return "F";
    return "Invalid";
  }

  String _calculateTriageGrade(double score, double possiblePoints) {
    double percent = (score / possiblePoints);
    if (percent > (17.0 / 18.0)) return "A";
    if (percent > (5.0 / 6.0)) return "B";
    if (percent > (2.0 / 3.0)) return "C";
    if (percent > (7.0 / 15.0)) return "D";
    if (percent <= (7.0 / 15.0)) return "F";
    return "Invalid";
  }

  String _validate(String value) {
    if (double.tryParse(value) == null || value.isEmpty) {
      return "Input must be a number";
    }
    return null;
  }

  Widget _scaleDropdown() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          children: [
            Text("Grading scale:"),
            DropdownButtonFormField(
                value: "Standard",
                items: <String>["Standard", "Triage"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String value) {
                  this._dropdown = value;
                })
          ],
        ));
  }

  Widget _scoreTextFiled() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
          hintText: "Input your score", border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        String _validation = _validate(value);
        if (_validation == null) {
          this._scoreInput = double.parse(value);
        }
        return _validation;
      },
    );
  }

  Widget _totalTextFiled() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
          hintText: "Input the total possible points",
          border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        String _validation = _validate(value);
        if (_validation == null) {
          double _total = double.parse(value);
          if (_total == 0) {
            return "Value cannot be zero";
          }
          this._possiblePointsInput = _total;
        }
        return _validation;
      },
    );
  }

  Widget _divisionBar() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Divider(
          color: Colors.black,
          indent: 20,
          endIndent: 20,
          thickness: 1,
        ));
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            this.grade._score = this._scoreInput;
            this.grade._possiblePoints = this._possiblePointsInput;
            print(this._dropdown);
            _onSubmit();
          }
        },
        child: Text('Convert'),
      ),
    );
  }

  Widget _gradeField() {
    return Flexible(
        child: this.grade._display ? Display(this.grade._grade) : Text(""));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _scaleDropdown(),
            _scoreTextFiled(),
            _divisionBar(),
            _totalTextFiled(),
            _submitButton(),
            _gradeField()
          ],
        ));
  }
}

class Display extends StatelessWidget {
  final String _grade;
  Display(this._grade);

  String _getGreetingText() {
    if (_grade == "A" || _grade == "Invalid") {
      return "You earned an";
    } else {
      return "You earned a";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        _getGreetingText(),
        textAlign: TextAlign.center,
      ),
      Text(
        _grade,
        textScaleFactor: 7,
        textAlign: TextAlign.center,
      )
    ]);
  }
}
