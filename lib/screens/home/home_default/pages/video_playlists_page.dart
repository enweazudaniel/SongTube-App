import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:songtube/internal/global.dart';
import 'package:songtube/languages/languages.dart';
import 'package:songtube/providers/content_provider.dart';
import 'package:songtube/providers/ui_provider.dart';
import 'package:songtube/ui/text_styles.dart';
import 'package:songtube/ui/tiles/stream_playlist_tile.dart';

class VideoPlaylistPage extends StatelessWidget {
  const VideoPlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: contentProvider.streamPlaylists.isEmpty
        ? _emptyPage(context)
        : _list(context),
    );
  }
  
  Widget _list(context) {
    ContentProvider contentProvider = Provider.of(context);
    UiProvider uiProvider = Provider.of(context);
    final playlists = contentProvider.streamPlaylists;
    return ListView.builder(
      padding: EdgeInsets.only(top: appBarSize(context)+6),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PlaylistTileExpanded(
            onTapOverride: () {
              contentProvider.loadLocalPlaylist(index);
              uiProvider.fwController.open();
            },
            playlist: playlists[index].toPlaylistInfoItem()),
        );
      },
    );
  }

  Widget _emptyPage(context) {
    return Center(child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: appBarSize(context)),
        const Icon(Ionicons.list, size: 64),
        const SizedBox(height: 8),
        Text(Languages.of(context)!.labelNoPlaylists, style: textStyle(context)),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Text(Languages.of(context)!.labelNoPlaylistsDescription, style: subtitleTextStyle(context, opacity: 0.6), textAlign: TextAlign.center,),
        ),
      ],
    ));
  }
}