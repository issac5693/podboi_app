import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:podboi/Controllers/podcast_page_controller.dart';
import 'package:podboi/Shared/detailed_episode_widget.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastPage extends StatelessWidget {
  final Item podcast;
  const PodcastPage({Key? key, required this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildTopUI(context),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  var _viewController = ref.watch(
                    podcastPageViewController(podcast),
                  );
                  Future<void> refresh() async {
                    ref
                        .read(podcastPageViewController(podcast).notifier)
                        .loadPodcastEpisodes(podcast.feedUrl!);
                  }

                  return _viewController.isLoading
                      ? Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 1,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Divider(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              );
                            },
                            itemCount: _viewController.podcastEpisodes.length,
                            itemBuilder: (context, index) {
                              Episode _episode =
                                  _viewController.podcastEpisodes[index];
                              return DetailedEpsiodeViewWidget(
                                  episode: _episode);
                            },
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildTopUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      height: 230.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Icon(Icons.arrow_back),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Hero(
                    tag: 'logo${podcast.collectionId}',
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Image.network(
                        podcast.bestArtworkUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.60,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        podcast.collectionName ?? 'N/A',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black.withOpacity(0.70),
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yMMMd')
                                    .format(podcast.releaseDate!),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black.withOpacity(0.50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 18.0,
                              ),
                              Text(
                                podcast.country ?? '',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black.withOpacity(0.50),
                                  // fontFamily: 'Segoe',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            child: Wrap(
                              children: podcast.genre!.map(
                                (i) {
                                  int x = podcast.genre!.indexOf(i);
                                  int l = podcast.genre!.length;
                                  String gName = i.name;
                                  if (x < l - 1) gName += " , ";
                                  return Text(
                                    gName,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black.withOpacity(0.70),
                                      fontFamily: 'Segoe',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  bool _isSubbed = ref.watch(
                    podcastPageViewController(podcast)
                        .select((value) => value.isSubscribed),
                  );
                  bool _isLoading = ref.watch(
                    podcastPageViewController(podcast)
                        .select((value) => value.isLoading),
                  );
                  return _isLoading
                      ? Container(
                          width: 110.0,
                          height: 1.0,
                          child: LinearProgressIndicator(
                            color: Colors.black,
                            backgroundColor: Colors.white,
                            minHeight: 1,
                          ),
                        )
                      : _isSubbed
                          ? GestureDetector(
                              onTap: () {
                                ref
                                    .read(podcastPageViewController(podcast)
                                        .notifier)
                                    .removeFromSubscriptionsAction(podcast);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Subscribed',
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Icon(FeatherIcons.checkCircle,
                                        color: Colors.green.withOpacity(0.7)),
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                ref
                                    .read(podcastPageViewController(podcast)
                                        .notifier)
                                    .saveToSubscriptionsAction(podcast);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Subscribe',
                                      style: TextStyle(
                                        fontFamily: 'Segoe',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Icon(FeatherIcons.plusCircle,
                                        color: Colors.orange.withOpacity(0.7)),
                                  ],
                                ),
                              ),
                            );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Content Advisory: ",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black.withOpacity(0.50),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${podcast.contentAdvisoryRating}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black.withOpacity(0.80),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6.0,
          ),
        ],
      ),
    );
  }
}