import 'package:app_movil_iptv/data/models/user.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/globals.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  HomeViewModel viewModelHome = HomeViewModel();

  late ClsUsers clsUsers = ClsUsers();
  late String? fechaCaducidad;

  @override
  void initState() {
    super.initState();
    clsUsers = Globals.globalUserAcount!;
    String? expDate = clsUsers.userInfo?.expDate;
    fechaCaducidad = viewModelHome.expirationDate(expDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: const Text('User Information'),
        backgroundColor: Colors.black38,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Const.imgBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              color: Const.colorPurpleDark.withOpacity(0.8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: const Text(
                            'Username',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          trailing: Text(
                            clsUsers.userInfo!.username ?? '',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: const Text(
                            'Status',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: clsUsers.userInfo!.status != "Active"
                                  ? Colors.red
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              clsUsers.userInfo!.status ?? '',
                              style: Const.fontBodyTextStyle.copyWith(
                                color: clsUsers.userInfo!.status == "Active"
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: const Text(
                            'Expiration Date',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          trailing: Text(
                            fechaCaducidad ?? '',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Utils.horizontalSpace(20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: const Text(
                            'Is Trial',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          trailing: Text(
                            clsUsers.userInfo!.isTrial == "1"
                                ? 'Free Trial'
                                : 'Paid Account',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.connect_without_contact,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: const Text(
                            'Active Connections',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          trailing: Text(
                            clsUsers.userInfo!.activeConnections ?? '',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: const Text(
                            'Max Connections',
                            style: Const.fontSubtitleTextStyle,
                          ),
                          trailing: Text(
                            clsUsers.userInfo!.maxConnections ?? '',
                            style: Const.fontBodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
