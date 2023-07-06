import 'package:tmdb_api/tmdb_api.dart';

class TMDBService {
  static final TMDB tmdbApi = TMDB(
    ApiKeys(
        '7ab52a3fc5886155dcc64bf2c02be07d', '4aba2b76bcc8dl20e2bf31b35206fade'),
    logConfig: const ConfigLogger.showNone(),
  );
}
