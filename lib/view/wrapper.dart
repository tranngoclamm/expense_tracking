import 'package:trackizer/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:trackizer/view/authenticate/authenticate.dart';
import 'package:trackizer/model/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return MainTabView();
    }
  }
}
