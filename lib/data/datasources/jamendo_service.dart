import 'dart:convert';

import 'package:http/http.dart' as http;

class JamendoService {
  final String clientId = "b15ef1da";
  final String baseUrl = "https://api.jamendo.com/v3.0";

  // Lấy 50 bài hát thịnh hành (Phổ biến nhất)
  Future<List<dynamic>> fetchPopularTracks() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/tracks/?client_id=$clientId&format=json&limit=50&order=popularity_total',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List;
    } else {
      print("Lỗi API Jamendo: ${response.body}");
      return [];
    }
  }

  // Tìm kiếm bài hát theo Tên khóa
  Future<List<dynamic>> searchTracks(String query) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/tracks/?client_id=$clientId&format=json&limit=20&search=$query',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Tìm kiếm thành công!");
      return data['results'];
    } else {
      print("Lỗi API Jamendo: ${response.body}");
      return [];
    }
  }

  // Lấy danh sách Nghệ sĩ (Artist) có hình ảnh
  Future<List<dynamic>> fetchPopularArtists() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/artists/?client_id=$clientId&format=json&limit=50&hasimage=true',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List;
    }
    return [];
  }

  // Lấy danh sách Album phổ biến thinh hanh
  Future<List<dynamic>> fetchPopularAlbums() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/albums/?client_id=$clientId&format=json&limit=50&order=popularity_total',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List;
    }
    return [];
  }

  // Lấy tracks theo albumId
  Future<List<dynamic>> fetchTracksByAlbumId(String albumId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/tracks/?client_id=$clientId&format=json&album_id=$albumId',
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'] as List;
    }
    return [];
  }

  // Lấy tracks theo artistId
  Future<List<dynamic>> fetchTracksByArtistId(String artistId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/tracks/?client_id=$clientId&format=json&artist_id=$artistId',
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'] as List;
    }
    return [];
  }

  // Lấy albums theo artistId
  Future<List<dynamic>> fetchAlbumsByArtistId(String artistId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/albums/?client_id=$clientId&format=json&artist_id=$artistId',
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'] as List;
    }
    return [];
  }
  // Lấy danh sách Playlist phổ biến (Thịnh hành) từ Jamendo
  Future<List<dynamic>> fetchPopularPlaylists() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/playlists/?client_id=$clientId&format=json&limit=20&order=popularity_total',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List;
    } else {
      print("Lỗi API Jamendo Playlists: ${response.body}");
      return [];
    }
  }
  // Lấy các bài hát trong 1 playlist cụ thể
  Future<List<dynamic>> fetchTracksByPlaylistId(String playlistId) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/playlists/tracks/?client_id=$clientId&format=json&id=$playlistId',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['tracks'] as List;
      }
      return [];
    }
    return [];
  }
}
