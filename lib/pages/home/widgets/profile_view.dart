import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:beatconnect_launch_mvp/lib.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    this.guest,
  });

  final DocumentSnapshot<Map<String, dynamic>>? guest;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentTab = 1;
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postCtrl = Get.find<PostCtrl>();
    Get.find<SpotifyCtrl>().loadTracksToAccount(widget.guest?.reference.id);

    return Stack(
      fit: StackFit.expand,
      children: [
        BackgroundProfile(
          scrollCtrl: _scrollCtrl,
          documentRef: widget.guest?.reference,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Get.theme.colorScheme.background,
                  Get.theme.colorScheme.background.withOpacity(0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [
                  0.5,
                  1.0,
                ]),
          ),
        ),
        StreamBuilder(
            stream: postCtrl.profilePosts(
              guestRef: widget.guest?.reference.path,
            ),
            builder: (context, snapshot) {
              var spotifyCtrl = Get.find<SpotifyCtrl>();
              return CustomScrollView(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    leadingWidth: 76,
                    toolbarHeight: kToolbarHeight + 50,
                    leading: HomeAppBarAction(
                      selected: true,
                      icon: MdiIcons.arrowLeft,
                      onTap: () {
                        if (widget.guest != null) {
                          Get.back();
                        } else {
                          Get.find<HomeCtrl>().goToReed();
                        }
                      },
                    ),
                    actions: [
                      if (widget.guest == null)
                        Obx(() {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                if (!spotifyCtrl.hasUserInfo) {
                                  spotifyCtrl.login();
                                } else {
                                  spotifyCtrl.logout();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: spotifyCtrl.hasUserInfo
                                      ? Colors.green
                                      : Get.theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      MdiIcons.spotify,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      "Spotify",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                      // ...[
                      //   HomeAppBarAction(
                      //     selected: true,
                      //     icon: MdiIcons.message,
                      //     onTap: () {
                      //       if (widget.guest == null) return;
                      //       Get.find<ChatCtrl>().openNewChat(
                      //         receiverRef: widget.guest!.reference.path,
                      //       );
                      //     },
                      //   ),
                      // ],
                      const SizedBox(width: 10.0),
                      if (widget.guest == null)
                        HomeAppBarAction(
                          selected: true,
                          icon: MdiIcons.dotsVertical,
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: _accountDetails(),
                  ),
                  SliverToBoxAdapter(
                    child: AccountFollowFollowers(
                      guest: widget.guest,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20.0),
                  ),
                  SliverToBoxAdapter(
                    child: ProfileTabBar(
                      children: [
                        ProfileTabBarItem(
                          label:
                              widget.guest != null ? "Sus gustos" : 'Tu música',
                          icon: MdiIcons.music,
                          selected: _currentTab == 0,
                          onTap: () {
                            setState(() {
                              _currentTab = 0;
                            });
                          },
                        ),
                        ProfileTabBarItem(
                            label: 'Posts',
                            icon: MdiIcons.post,
                            selected: _currentTab == 1,
                            onTap: () {
                              setState(() {
                                _currentTab = 1;
                              });
                            }),
                        if (widget.guest == null ||
                            widget.guest
                                    ?.data()?['profileTripStatusVisibility'] ==
                                "everyone" ||
                            widget.guest
                                    ?.data()?['profileTripStatusVisibility'] ==
                                null)
                          ProfileTabBarItem(
                              label: 'Visitas',
                              icon: MdiIcons.sitemap,
                              selected: _currentTab == 2,
                              onTap: () {
                                setState(() {
                                  _currentTab = 2;
                                });
                              }),
                      ],
                    ),
                  ),
                  if (_currentTab == 0) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          "Tu música recientemente escuchada",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ...Get.find<SpotifyCtrl>().tracks.map(
                      (item) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: TrackItem(
                              item: item,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  if (_currentTab == 1 &&
                          snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none)
                    const SliverToBoxAdapter(
                      child: LoadingPostSkeleton(),
                    ),
                  if (_currentTab == 1 &&
                      snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData &&
                      snapshot.data!.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Center(
                            child: PostItem(
                              isReed: widget.guest != null,
                              snapshot: snapshot.data![index],
                            ),
                          );
                        },
                        childCount: snapshot.data?.length ?? 0,
                      ),
                    ),
                  if (_currentTab == 2)
                    SliverToBoxAdapter(
                      child: StreamBuilder(
                          stream: Get.find<ProfileCtrl>()
                              .getAccountStream(widget.guest?.reference.path),
                          builder: (context, snapshot) {
                            var isBusiness =
                                snapshot.data?.data()?['type'] == 0;
                            return StreamBuilder(
                              stream: !isBusiness
                                  ? Get.find<ProfileCtrl>().getBusinessVisits(
                                      accountRef: widget.guest?.reference.path,
                                    )
                                  : Get.find<ProfileCtrl>().getVisitors(
                                      accountRef: widget.guest?.reference.path,
                                    ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(
                                    height: 180.0,
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.all(16.0),
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                        5,
                                        (index) => const BusinessItemSkeleton(),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    (snapshot.data?.isEmpty ?? false)) {
                                  return const SizedBox.shrink();
                                }
                                return SizedBox(
                                  height: 180,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(16.0),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var item = snapshot.data![index];
                                      return BusinessItem(
                                        item: item,
                                        isBusiness: !isBusiness,
                                      );
                                    },
                                    itemCount: snapshot.data?.length ?? 0,
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100.0),
                  )
                ],
              );
            }),
      ],
    );
  }

  Widget _accountDetails() {
    String lastActiveString = "";
    var controller = Get.find<ProfileCtrl>();
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: StreamBuilder(
              stream: controller.getAccountStream(
                widget.guest?.reference.path,
              ),
              builder: (context, snapshot) {
                var data = snapshot.data?.data();
                final cantViewStatus =
                    privacyFromValue(data?['profileStatusVisibility']) ==
                        SettingsPrivacyView.nobody;

                var hasAddress = data?['address'] != null;
                var hasActiveStatus = data?.containsKey('active') ?? false
                    ? data!['active']
                    : false;
                var hasLastActive = data?['lastActive'] != null;
                lastActiveString = cantViewStatus
                    ? ""
                    : hasLastActive
                        ? "Activo ${data?['active'] ?? false ? "ahora" : TimeUtils.timeagoFormat(data?["lastActive"].toDate())}"
                        : lastActiveString;
                final profileVisibilityEveryone =
                    privacyFromValue(data?['profileAvatarVisibility']) ==
                        SettingsPrivacyView.everyone;
                final image = data?['image'];
                final isACurrentAccount =
                    controller.isCurrentAccount(widget.guest?.reference.path);
                final cantViewBusinessStatus = privacyFromValue(snapshot.data
                        ?.data()?["profileBusinessStatusVisibility"]) ==
                    SettingsPrivacyView.nobody;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileImage(
                        isBusiness: data?['type'] == 0,
                        hasVisit: cantViewBusinessStatus
                            ? false
                            : data?['currentVisit'] != null,
                        name: data?['name'],
                        image: isACurrentAccount
                            ? image
                            : profileVisibilityEveryone
                                ? image
                                : null,
                        active: cantViewStatus ? false : hasActiveStatus,
                        avatarSize: 130.0,
                        fontSize: 40.0,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data?['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isACurrentAccount) ...[
                            const SizedBox(width: 10.0),
                            ImagePicker(
                              canRemove: false,
                              onImageSelected: (image) {
                                if (image == null) return;
                                Get.find<ProfileCtrl>().changeAvatar(image);
                              },
                              child: const Icon(
                                Icons.camera_alt,
                                size: 30.0,
                              ),
                            )
                          ]
                        ],
                      ),
                      if (!cantViewBusinessStatus &&
                          data?['currentVisit'] != null) ...[
                        const SizedBox(
                          height: 10.0,
                        ),
                        StreamBuilder(
                            stream: Get.find<ProfileCtrl>()
                                .getFollowingInCurrentVisit(
                                    accountRef: widget.guest?.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              if (snapshot.data == null) {
                                return const SizedBox.shrink();
                              }
                              var length = snapshot.data?.length ?? 0;
                              var limit = 4;
                              var items = length >= limit ? limit : length;
                              var hasMore = length > limit;
                              var hasAlone = length == 0;
                              var offsetX = (160.0 - (25.0 * items)) / 2.25;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Transform.translate(
                                    offset: Offset(offsetX, 0.0),
                                    child: SizedBox(
                                      width: 160.0,
                                      child: Row(
                                        children: [
                                          ...List.generate(
                                            items,
                                            (index) => StreamBuilder(
                                                stream: Get.find<ProfileCtrl>()
                                                    .getAccountStream(
                                                  snapshot.data![index],
                                                ),
                                                builder: (context, account) {
                                                  return Transform.translate(
                                                    offset: Offset(
                                                      index * -15.0,
                                                      0.0,
                                                    ),
                                                    child: ProfileImage(
                                                      image: account
                                                          .data?['image'],
                                                      name:
                                                          account.data?['name'],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  StreamBuilder(
                                      stream: Get.find<ProfileCtrl>()
                                          .getAccountStream(
                                              data!['currentVisit']),
                                      builder: (context, business) {
                                        if (business.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox.shrink();
                                        }
                                        if (business.data == null) {
                                          return const SizedBox.shrink();
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              hasAlone
                                                  ? "esta en"
                                                  : "${hasMore ? "y otras personas mas" : ""} estan en ",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Get.theme.colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes.guestProfile,
                                                    arguments: business.data);
                                              },
                                              child: ProfileImage(
                                                image: business.data?['image'],
                                                name: business.data?['name'],
                                              ),
                                            ),
                                            Text(
                                              business.data?['name']
                                                      ?.toUpperCase() ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Get.theme.colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                      if (hasAddress)
                        Text(
                          data?['address'] ?? '',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Get.theme.colorScheme.primary),
                        ),
                      const SizedBox(height: 10.0),
                      Text(
                        lastActiveString,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: data?["active"] ?? false
                              ? Get.theme.colorScheme.primary
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class LoadingPostSkeleton extends StatelessWidget {
  const LoadingPostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PostSkeleton(),
        PostSkeleton(),
        PostSkeleton(),
      ],
    );
  }
}
