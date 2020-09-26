import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Use arrow notation for one line method definitions
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Calculator',
      home: Scaffold(
        appBar: AppBar(title: Text('Grade Calculator')),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 600,
            ),
            padding: EdgeInsets.all(20.0),
            child: Grade(),
          ),
        ),
      ),
    );
  }
}

class GradeModel {
  bool _displayGrade;
  String _grade;
  int _score;
  String _item;

  GradeModel() {
    _displayGrade = false;
    _grade = '';
  }
}

class Grade extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
  final _formKey = GlobalKey<FormState>();
  GradeModel model = new GradeModel();

  void _onSubmit() {
    this._formKey.currentState.save();
    setState(() {
      this.model._displayGrade = true;
      this.model._grade = calculateGrade(this.model._score);
    });
  }

  void _onFail() {
    setState(() {
      this.model._displayGrade = false;
    });
  }

  String calculateGrade(int score) {
    if (score < 60) return 'F';
    if (score < 70) return 'D';
    if (score < 80) return 'C';
    if (score < 90) return 'B';
    return 'A';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey.withOpacity(1),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: Offset(-5, 5),
              spreadRadius: 0,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: this.model._displayGrade
                        ? Radius.circular(0)
                        : Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: this.model._displayGrade
                        ? Radius.circular(0)
                        : Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScoreInput(
                      (String newValue) {
                        this.model._score = int.parse(newValue);
                      },
                    ),
                    SubmitButton(_formKey, _onSubmit, _onFail),
                  ],
                ),
              ),
            ),
            Flexible(
              child: this.model._displayGrade
                  ? GradeDisplay(this.model._grade)
                  : Text(''),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final _formKey;
  final _onSubmit;
  final _onFail;
  SubmitButton(this._formKey, this._onSubmit, this._onFail);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: RaisedButton(
        onPressed: () {
          if (this._formKey.currentState.validate()) {
            this._onSubmit();
          } else {
            this._onFail();
          }
        },
        child: Text('Submit'),
      ),
    );
  }
}

class ScoreInput extends StatefulWidget {
  final _onSaved;
  ScoreInput(this._onSaved);
  @override
  _ScoreInputState createState() => _ScoreInputState(_onSaved);
}

class _ScoreInputState extends State<ScoreInput> {
  var _onSaved;
  _ScoreInputState(this._onSaved);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(hintText: 'Enter your score'),
      onSaved: (newValue) => this._onSaved(newValue),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your score';
        }
        return null;
      },
    );
  }
}

class GradeDisplay extends StatelessWidget {
  final String _grade;
  GradeDisplay(this._grade);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            _grade,
            textScaleFactor: 8.99,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
