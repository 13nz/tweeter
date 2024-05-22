import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/common/error_page.dart';
import 'package:twitter/common/loading_page.dart';
import 'package:twitter/constants/appwrite_constants.dart';
import 'package:twitter/features/tweet/controller/tweet_controller.dart';
import 'package:twitter/features/tweet/widgets/tweet_card.dart';
import 'package:twitter/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
                data: (data) {
                  if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                  )) {
                    tweets.insert(
                      0,
                      Tweet.fromMap(data.payload),
                    );
                  } else if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                  )) {
                    // get id of tweet
                    var startingIndex =
                        data.events[0].lastIndexOf('documents.');
                    var endIndex = data.events[0].lastIndexOf('.update');

                    // + 10 to ignore 'documents.'
                    final tweetId =
                        data.events[0].substring(startingIndex + 10, endIndex);

                    var tweet =
                        tweets.where((element) => element.id == tweetId).first;

                    final tweetIndex = tweets.indexOf(tweet);
                    tweets.removeWhere((element) => element.id == tweetId);

                    tweet = Tweet.fromMap(data.payload);
                    tweets.insert(tweetIndex, tweet);
                  }

                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () {
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(tweet: tweet);
                    },
                  );
                },
              );
        },
        error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
        loading: () => const Loader());
  }
}
