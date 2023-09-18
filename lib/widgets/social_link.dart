import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sition/services/save_data_service.dart';

class socialLink extends StatefulWidget {
  final String linkingName;
  final bool isLinked;
  final dynamic socialLinker;
  final dynamic loginFunction;
  const socialLink({
    required this.socialLinker,
    required this.loginFunction,
    required this.linkingName,
    required this.isLinked,
    Key? key,
  }) : super(key: key);

  @override
  _socialLinkState createState() => _socialLinkState();
}

class _socialLinkState extends State<socialLink> {
  final GetIt getIt = GetIt.instance;
  unlinkSocial() async {
    widget.socialLinker(widget.linkingName, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: Container(
                color: Color(0xFF202020),
                child: TextButton(
                  onPressed: () {
                    if (!widget.isLinked) {
                      widget.loginFunction();
                    } else {
                      unlinkSocial();
                    }
                  },
                  child: Text(
                    '${widget.isLinked == true ? 'Unlink' : 'Link'} ${widget.linkingName}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    widget.linkingName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
