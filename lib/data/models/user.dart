class ClsUsers {
  final ClsUserInfo? userInfo;
  final ClsUserServerInfo? serverInfo;

  ClsUsers({
    this.userInfo,
    this.serverInfo,
  });

  factory ClsUsers.fromJson(Map<String, dynamic> json) => ClsUsers(
        userInfo: (json['user_info'] as Map<String, dynamic>?) != null
            ? ClsUserInfo.fromJson(json['user_info'] as Map<String, dynamic>)
            : null,
        serverInfo: (json['server_info'] as Map<String, dynamic>?) != null
            ? ClsUserServerInfo.fromJson(
                json['server_info'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'user_info': userInfo?.toJson(),
        'server_info': serverInfo?.toJson(),
      };
}

class ClsUserInfo {
  final String? username;
  final String? password;
  final String? message;
  final String? auth;
  final String? status;
  final String? expDate;
  final String? isTrial;
  final String? activeConnections;
  final String? createdAt;
  final String? maxConnections;
  final List<String>? allowedOutputFormats;

  ClsUserInfo({
    this.username,
    this.password,
    this.message,
    this.auth,
    this.status,
    this.expDate,
    this.isTrial,
    this.activeConnections,
    this.createdAt,
    this.maxConnections,
    this.allowedOutputFormats,
  });

  factory ClsUserInfo.fromJson(Map<String, dynamic> json) => ClsUserInfo(
        username: json['username'].toString(),
        password: json['password'].toString(),
        message: json['message'].toString(),
        auth: json['auth'].toString(),
        status: json['status'].toString(),
        expDate: json['exp_date'].toString(),
        isTrial: json['is_trial'].toString(),
        activeConnections: json['active_cons'].toString(),
        createdAt: json['created_at'].toString(),
        maxConnections: json['max_connections'].toString(),
        allowedOutputFormats: (json['allowed_output_formats'] as List?)
            ?.map((dynamic e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'message': message,
        'auth': auth,
        'status': status,
        'exp_date': expDate,
        'is_trial': isTrial,
        'active_cons': activeConnections,
        'created_at': createdAt,
        'max_connections': maxConnections,
        'allowed_output_formats': allowedOutputFormats
      };
}

class ClsUserServerInfo {
  final String? url;
  final String? port;
  final String? httpsPort;
  final String? serverProtocol;
  final String? rtmpPort;
  final String? timezone;
  final String? timestampNow;
  final String? timeNow;
  final String? process;
  final String? serverUrl;

  ClsUserServerInfo({
    this.url,
    this.port,
    this.httpsPort,
    this.serverProtocol,
    this.rtmpPort,
    this.timezone,
    this.timestampNow,
    this.timeNow,
    this.process,
    this.serverUrl,
  });

  factory ClsUserServerInfo.fromJson(Map<String, dynamic> json) =>
      ClsUserServerInfo(
        url: json['url'].toString(),
        port: json['port'].toString(),
        httpsPort: json['https_port'].toString(),
        serverProtocol: json['server_protocol'].toString(),
        rtmpPort: json['rtmp_port'].toString(),
        timezone: json['timezone'].toString(),
        timestampNow: json['timestamp_now'].toString(),
        timeNow: json['time_now'].toString(),
        process: json['process'].toString(),
        serverUrl: (json['server_url']).toString(),
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'port': port,
        'https_port': httpsPort,
        'server_protocol': serverProtocol,
        'rtmp_port': rtmpPort,
        'timezone': timezone,
        'timestamp_now': timestampNow,
        'time_now': timeNow,
        'process': process,
        'server_url': serverUrl
      };
}
