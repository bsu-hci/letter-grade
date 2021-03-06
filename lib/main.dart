import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grade Calculator",
      theme: ThemeData(primaryColor: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
            title: Text(
          "Grade Calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
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

  void _onSubmit() {
    setState(() {
      this.grade._display = true;
      if (this.radioButtonItem == "Standard") {
        this.grade._grade = _calculateStandardGrade(
            this.grade._score, this.grade._possiblePoints);
      }
      if (this.radioButtonItem == "Triage") {
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

  int id = 1;
  String radioButtonItem = 'Standard';
  Widget _radioButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'Standard';
                    id = 1;
                  });
                },
              ),
              Text(
                'Standard',
                style: new TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Radio(
                value: 2,
                groupValue: id,
                onChanged: (val) {
                  setState(() {
                    radioButtonItem = 'Triage';
                    id = 2;
                  });
                  radioButtonItem = 'Triage';
                  id = 2;
                },
              ),
              Text(
                'Triage',
                style:
                    new TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreTextFiled() {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
          hintText: "Input your score", border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
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
          hintText: "Input Total Points", border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
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

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            this.grade._score = this._scoreInput;
            this.grade._possiblePoints = this._possiblePointsInput;
            print(this.radioButtonItem);
            _onSubmit();
          }
        },
        child: Text('Enter'),
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
            _radioButton(),
            _scoreTextFiled(),
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
      return "You Grade is an";
    } else {
      return "Your Grade is a";
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
