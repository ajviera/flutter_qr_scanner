import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/src/common/general_regex.dart';
import 'package:qr_scanner/src/helpers/validator.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';
import 'package:qr_scanner/src/services/auth.dart';
import 'package:qr_scanner/src/themes/ui_dark.dart';
import 'package:qr_scanner/src/widgets/loading_popup.dart';
import 'package:qr_scanner/src/widgets/raised_gradient_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  static final formKey = GlobalKey<FormState>();
  Validator validator;
  String _email;
  String _password;
  FormType _formType = FormType.login;
  final double _buttonHeight = 44.0;
  bool _obscureText = true;
  IconData _passwordIcon = Icons.visibility_off;
  FocusNode textFirstFocusNode = FocusNode();
  FocusNode textSecondFocusNode = FocusNode();

  AnimationController _controller;
  Animation _animation;
  double _topLogoPadding = 70.0;
  bool _logoIsVisible = true;
  double _logoHeightPercent = 0.35;
  double _logoWidthPercent = 0.35;
  var _curvesAnimation;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      validator = Validator(context: context);
    });
    _curvesAnimation = Curves.easeIn;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _curvesAnimation,
      ),
    );

    textFirstFocusNode.addListener(_textFirstFocusNodeFocusChange);
    textSecondFocusNode.addListener(_textSecondFocusNodeFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    textFirstFocusNode.dispose();
    textSecondFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _textFirstFocusNodeFocusChange() {
    setState(() {
      if (textFirstFocusNode.hasFocus) {
        _topLogoPadding = 10.0;
        _logoIsVisible = false;
        _logoHeightPercent = 0.12;
        _logoWidthPercent = 0.12;
      } else {
        if (!textSecondFocusNode.hasFocus) {
          _logoIsVisible = true;
          _topLogoPadding = 70.0;
          _logoHeightPercent = 0.35;
          _logoWidthPercent = 0.35;
        }
      }
    });
  }

  void _textSecondFocusNodeFocusChange() {
    setState(() {
      if (textSecondFocusNode.hasFocus) {
        _topLogoPadding = 10.0;
        _logoIsVisible = false;
        _logoHeightPercent = 0.12;
        _logoWidthPercent = 0.12;
      } else {
        if (!textFirstFocusNode.hasFocus) {
          _logoIsVisible = true;
          _topLogoPadding = 70.0;
          _logoHeightPercent = 0.35;
          _logoWidthPercent = 0.35;
        }
      }
    });
  }

  void _resetTextFocus() {
    textFirstFocusNode.unfocus();
    textSecondFocusNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _resetTextFocus(),
      child: Scaffold(
        backgroundColor: UiDark().backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _logo(),
                  _fieldsCard(),
                  _loginWithGoogleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    var duration = const Duration(milliseconds: 500);
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width * _logoWidthPercent,
      height: MediaQuery.of(context).size.height * _logoHeightPercent,
      duration: duration,
      curve: _curvesAnimation,
      padding: EdgeInsets.only(top: _topLogoPadding),
      child: AnimatedOpacity(
        curve: _curvesAnimation,
        duration: duration,
        opacity: _logoIsVisible ? 1.0 : 0.0,
        child: FadeTransition(
          opacity: _animation,
          child: Image(
            image: AssetImage('assets/images/main_logo.png'),
          ),
        ),
      ),
    );
  }

  Widget _loginWithGoogleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
      child: RaisedGradientButton(
        key: Key('login/register'),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image(
                    image: AssetImage('assets/images/google-logo-1.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
                Text(
                  ProviderManager.languageChangeNotifier()
                      .getStrings()
                      .loginWithGoogle,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        height: _buttonHeight,
        onPressed: () => validateAndSubmitWithGoogleAuth(),
        gradient: UiDark().buttonGradient,
      ),
    );
  }

  Widget _fieldsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      elevation: 7.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: usernameAndPassword() + submitWidgets(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    _resetTextFocus();
    if (validateAndSave()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingPopup(
          future: () async {
            return _formType == FormType.login
                ? await Auth().signIn(_email, _password)
                : await Auth().createUser(_email, _password);
          },
          successFunction: () => ProviderManager.appGeneralNotifier().login(),
          failFunction: () => {},
        ),
      );
    }
  }

  void validateAndSubmitWithGoogleAuth() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    await _useGoogle();
  }

  _useGoogle() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LoadingPopup(
        future: () async {
          return await Auth().signInWithGoogle();
        },
        successFunction: () => ProviderManager.appGeneralNotifier().login(),
        failFunction: () => {},
      ),
    );
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _obscureText = true;
      _passwordIcon = Icons.visibility_off;
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _obscureText = true;
      _passwordIcon = Icons.visibility_off;
      _formType = FormType.login;
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
        child: TextFormField(
          key: Key('email'),
          onFieldSubmitted: (String value) {
            FocusScope.of(context).requestFocus(textSecondFocusNode);
          },
          focusNode: textFirstFocusNode,
          decoration: InputDecoration(
              labelText:
                  ProviderManager.languageChangeNotifier().getStrings().email),
          autocorrect: false,
          validator: (val) => validator.emailValidator(val),
          onSaved: (val) => _email = val,
          inputFormatters: [
            WhitelistingTextInputFormatter(
              GeneralRegex.regexWithoutSpace,
            ),
            LengthLimitingTextInputFormatter(32),
          ],
        ),
      ),
      padded(
        child: TextFormField(
          key: Key('password'),
          focusNode: textSecondFocusNode,
          decoration: InputDecoration(
            labelText:
                ProviderManager.languageChangeNotifier().getStrings().password,
            suffixIcon: IconButton(
              icon: Icon(_passwordIcon),
              onPressed: () => _toggle(),
            ),
          ),
          obscureText: _obscureText,
          autocorrect: false,
          validator: (val) => validator.passwordValidator(val),
          onSaved: (val) => _password = val,
          inputFormatters: [
            WhitelistingTextInputFormatter(
              GeneralRegex.regexWithoutSpace,
            )
          ],
        ),
      ),
    ];
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText) {
        _passwordIcon = Icons.visibility_off;
      } else {
        _passwordIcon = Icons.visibility;
      }
    });
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          RaisedGradientButton(
            key: Key('login'),
            child: Text(
              ProviderManager.languageChangeNotifier().getStrings().login,
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
            height: _buttonHeight,
            onPressed: validateAndSubmit,
            gradient: UiDark().buttonGradient,
          ),
          FlatButton(
            key: Key('need-account'),
            child: Text(ProviderManager.languageChangeNotifier()
                .getStrings()
                .needAccount),
            onPressed: moveToRegister,
          )
        ];
      case FormType.register:
        return [
          RaisedGradientButton(
            key: Key('register'),
            child: Text(
              ProviderManager.languageChangeNotifier().getStrings().register,
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
            height: _buttonHeight,
            onPressed: validateAndSubmit,
            gradient: UiDark().buttonGradient,
          ),
          FlatButton(
            key: Key('need-login'),
            child: Text(ProviderManager.languageChangeNotifier()
                .getStrings()
                .haveAccount),
            onPressed: moveToLogin,
          )
        ];
    }
    return null;
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
