import 'package:app_movil_iptv/data/models/user.dart';
import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/globals.dart';
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
          child: Center(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('') ),
                DataColumn(label: Text('')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(
                      Text('Username', style: Const.fontSubtitleTextStyle)),
                  DataCell(Text(clsUsers.userInfo?.username ?? '',
                      style: Const.fontBodyTextStyle)),
                ]),
                DataRow(cells: [
                  const DataCell(
                      Text('Status', style: Const.fontSubtitleTextStyle)),
                  DataCell(
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: clsUsers.userInfo?.status != "Active"
                            ? Colors.red
                            : Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          clsUsers.userInfo?.status ?? '',
                          style: Const.fontBodyTextStyle
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Expiration Date',
                      style: Const.fontSubtitleTextStyle)),
                  DataCell(Text(
                    fechaCaducidad ?? '',
                    style: Const.fontBodyTextStyle,
                  )),
                ]),
                DataRow(cells: [
                  const DataCell(
                      Text('Is Trial', style: Const.fontSubtitleTextStyle)),
                  DataCell(
                    Text(
                      clsUsers.userInfo?.isTrial == "1"
                          ? "Free Trial"
                          : "Paid Account",
                      style:
                          Const.fontBodyTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Active Connections',
                      style: Const.fontSubtitleTextStyle)),
                  DataCell(Text(
                      clsUsers.userInfo?.activeConnections?.toString() ?? '',
                      style: Const.fontBodyTextStyle)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Max Connections',
                      style: Const.fontSubtitleTextStyle)),
                  DataCell(Text(clsUsers.userInfo?.maxConnections ?? '',
                      style: Const.fontBodyTextStyle)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
