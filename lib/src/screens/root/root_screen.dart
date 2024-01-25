import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../global/utilities/toast.dart';
import '../../global_bloc/connectivity/connectivity_bloc.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var db = FirebaseFirestore.instance;
    final data = await db.collection('alo').doc('CKU8cm74rGdguPPLWFnc').get();
    final res = data.data() as Map<String, dynamic>;
    print(res['Hello']);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityChangedState) {
          if (state.result == ConnectivityResult.none) {
            appToast(context, message: "No connection");
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AppBar(),
      ),
    );
  }
}
