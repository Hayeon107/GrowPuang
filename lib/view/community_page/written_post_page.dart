import 'package:growpuang/controller/language_controller.dart';
import 'package:growpuang/controller/post_controller.dart';
import 'package:growpuang/controller/post_list_controller.dart';
import 'package:growpuang/controller/personal_contoller.dart';
import 'package:growpuang/mainPage.dart';
import 'package:growpuang/model/firebase_read_write.dart';
import 'package:flutter/material.dart';
import 'package:growpuang/model/loading_dialog.dart';
import 'package:growpuang/styles.dart';
import 'package:growpuang/view/community_screen.dart';
import 'package:growpuang/class/post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:growpuang/view/widget/appBar.dart';

class WrittenPostPage extends StatefulWidget {
  Post post = Post('', 0, '', [], [], [], 0, '', 1);
  int index = 0;

  WrittenPostPage(this.post, this.index);

  @override
  _WrittenPostPageState createState() => _WrittenPostPageState();
}

class _WrittenPostPageState extends State<WrittenPostPage> {
  TextEditingController commentController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final postController = Get.put(PostController());
  final postListController = Get.put(PostListController());
  final personalController = Get.put(PersonalController());
  final languageController = Get.put(LanguageController());

  void checkCountedCommentWriterList() {
    postController.countedCommentWriterList = [];

    for (int i = 0; i < postController.post.commentWriterList.length; i++) {
      if (!postController.countedCommentWriterList
          .contains(postController.post.commentWriterList[i])) {
        postController.countedCommentWriterList
            .add(postController.post.commentWriterList[i]);
      }
    }
  }

  @override
  initState() {
    postController.post = widget.post;
    postController.index = widget.index;

    //만약 작성자가 게시글을 보고있는 경우, 수정이랑 삭제도 보여져야함'
    if (postController.post.postWriter == personalController.userId as String) {
      postController.threeDotsCommendList = [
        languageController.communityWrittenPostRefresh,
        languageController.communityWrittenPostReport,
        languageController.communityWrittenPostEdit,
        languageController.communityWrittenPostDelete
      ];
    } else {
      postController.threeDotsCommendList = [
        languageController.communityWrittenPostRefresh,
        languageController.communityWrittenPostReport
      ];
    }

    checkCountedCommentWriterList();

    super.initState();
    // commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: SizedBox(
      //   width: 100.w,
      //   child: FittedBox(
      //     fit: BoxFit.fill,
      //     child: FloatingActionButton(
      //       backgroundColor: communityMainColor,
      //       child: Icon(
      //         Icons.thumb_up_alt_outlined,
      //         color: whiteTextColor,
      //       ),
      //       elevation: 5,
      //       onPressed: () {
      //         if (postController.post.recommendList
      //             .contains(personalController.userId as String)) {
      //           showDialog(
      //             context: context,
      //             builder: (BuildContext context) {
      //               Future.delayed(
      //                 Duration(seconds: 1),
      //                 () {
      //                   Navigator.of(context, rootNavigator: true).pop();
      //                 },
      //               );
      //               return AlertDialog(
      //                 content: SizedBox(
      //                   width: 400.w,
      //                   height: 120.h,
      //                   child: Center(
      //                     child: Text(
      //                       languageController.communityAlreadyLikedMessage,
      //                       style: TextStyle(
      //                           color: mainTextColor,
      //                           letterSpacing: 2.w,
      //                           fontFamily: 'Inter',
      //                           fontWeight: FontWeight.w500,
      //                           fontSize: 22.sp),
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             },
      //           );
      //         } else {
      //           setState(
      //             () {
      //               fb_add_recommend(
      //                   postController.post.postNum,
      //                   personalController.userId as String,
      //                   postController.post
      //                       .recommendNum); // 좋아요 추가 - 게시글 제목, 누른사람, 기존 좋아요 개수
      //               postController.post.recommendNum++;
      //               postController.post.recommendList
      //                   .add(personalController.userId as String);
      //             },
      //           );
      //         }
      //       },
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          appBar(),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: communityMainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text(
                            languageController.communityAppBarText,
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: whiteTextColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Text(
                            languageController.communityAppBarSubText(
                                personalController.communityResult),
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontFamily: 'Inter',
                                color: whiteTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: mainBackgroundColor.withOpacity(0.95),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.menu,
                                color: communityMainColor,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                postListController.selectedSort,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    color: communityMainColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () async {
                              //기다리는 동안 로딩창 띄우기
                              loadingDialog(context);

                              await postListController.readOnePostData(
                                  postController.index,
                                  postController.post.postNum);

                              print("새로고침");

                              //화면 이동 전, 로딩 다이어로그 pop!
                              Navigator.of(context, rootNavigator: true).pop();

                              //새로고침을 위하여 기존 화면 스택을 날리고 다시 시작함
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (_) => false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()),
                              );

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommunityScreen()));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WrittenPostPage(
                                      postController.post,
                                      postController.index),
                                ),
                              );
                            },
                            child: Icon(Icons.refresh_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: mainBackgroundColor.withOpacity(0.97),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 80.h,
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          postListController.sortList[
                                              postController.post.sortOpt],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${postController.post.postTitle}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              //letterSpacing: 2.w,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 28.h,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 0, 12.h, 0),
                                      child: Text(
                                        languageController.anonymousAuthor,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 36.w), // 시작 위치를 오른쪽으로 옮김
                                  child: SelectableText.rich(
                                    TextSpan(
                                      text: (postController.post.postContent),
                                      style: TextStyle(
                                        color: mainTextColor,
                                        letterSpacing: 1.w,
                                        fontFamily: 'Inter',
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Container(
                            width: double.infinity,
                            height: 40.h,
                            margin: EdgeInsets.fromLTRB(0, 0, 12.h, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: TextButton(
                                    child: Text(
                                      languageController
                                          .communityWrittenPostReport,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: mainTextColor,
                                        fontFamily: 'Inter',
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    onPressed: () => postReport(),
                                  ),
                                ),
                                postController.post.postWriter ==
                                        personalController.userId as String
                                    ? Container(
                                        child: TextButton(
                                          child: Text(
                                            languageController
                                                .communityWrittenPostEdit,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: mainTextColor,
                                              fontFamily: 'Inter',
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          onPressed: () => modifyContent(),
                                        ),
                                      )
                                    : SizedBox(),
                                postController.post.postWriter ==
                                        personalController.userId as String
                                    ? Container(
                                        child: TextButton(
                                          child: Text(
                                            languageController
                                                .communityWrittenPostDelete,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: mainTextColor,
                                              fontFamily: 'Inter',
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          onPressed: () => deletePost(),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 2.w, 0),
                            height: 32.h,
                            child: Icon(Icons.chat_bubble_outline),
                          ),
                          Text(
                            '${postController.post.commentList.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24.sp,
                            ),
                          ),
                          Container(
                            width: 50.w,
                            height: 32.h,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
                            child: IconButton(
                              icon: Icon(
                                Icons.thumb_up_alt_outlined,
                                color: mainTextColor,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Make the button transparent
                                elevation: 0, // Remove button shadow
                              ),
                              onPressed: () {
                                if (postController.post.recommendList.contains(
                                    personalController.userId as String)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      Future.delayed(
                                        Duration(seconds: 1),
                                        () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      );
                                      return AlertDialog(
                                        content: SizedBox(
                                          width: 400.w,
                                          height: 120.h,
                                          child: Center(
                                            child: Text(
                                              languageController
                                                  .communityAlreadyLikedMessage,
                                              style: TextStyle(
                                                  color: mainTextColor,
                                                  letterSpacing: 1.w,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.sp),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  setState(
                                    () {
                                      fb_add_recommend(
                                          postController.post.postNum,
                                          personalController.userId as String,
                                          postController.post
                                              .recommendNum); // 좋아요 추가 - 게시글 제목, 누른사람, 기존 좋아요 개수
                                      postController.post.recommendNum++;
                                      postController.post.recommendList.add(
                                          personalController.userId as String);
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          Text(
                            '${postController.post.recommendList.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: communityMainColor.withOpacity(0.6),
                            width: 1.2, // 선의 두께
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Column(
                          children: List.generate(
                              postController.post.commentList.length, (i) {
                            return Container(
                              margin:
                                  EdgeInsets.fromLTRB(28.w, 12.h, 20.w, 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${languageController.anonymous} ${postController.countedCommentWriterList.indexOf(postController.post.commentWriterList[i]) + 1}",
                                        style: TextStyle(
                                          color: mainTextColor,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      if (postController
                                              .post.commentWriterList[i] ==
                                          personalController.userId as String)
                                        Container(
                                          height: 32.h,
                                          child: TextButton(
                                            onPressed: () => deleteComment(i),
                                            child: Text(
                                              languageController
                                                  .communityWrittenPostDelete,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: mainTextColor,
                                                fontFamily: 'Inter',
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    postController.post.commentList[i],
                                    style: TextStyle(
                                      color: mainTextColor,
                                      letterSpacing: 1.w,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 60.h,
                            child: TextField(
                              controller: commentController,
                              style: TextStyle(
                                  color: mainTextColor,
                                  letterSpacing: 1.w,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: commmentBackGroundColor, // 배경 색상 설정
                                hintText: languageController.commentPlaceholder,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: mainBackgroundColor),
                                  borderRadius:
                                      BorderRadius.circular(12.0), // 둥근 테두리 설정
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.w,
                            bottom: 6.h,
                            child: TextButton(
                              onPressed: () {
                                if (commentController.text == '') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      Future.delayed(
                                        Duration(seconds: 1),
                                        () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                      );
                                      return AlertDialog(
                                        content: SizedBox(
                                          width: 400.w,
                                          height: 120.h,
                                          child: Center(
                                            child: Text(
                                              languageController
                                                  .incompleteFieldsMessage,
                                              style: TextStyle(
                                                  color: mainTextColor,
                                                  letterSpacing: 1.w,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.sp),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    postController.post.commentWriterList.add(
                                        personalController.userId as String);
                                    postController.post.commentList
                                        .add(commentController.text);

                                    fb_add_comment(
                                        postController.post.postNum,
                                        postController.post.commentList.last,
                                        postController.post
                                            .commentWriterList); // 댓글 추가 - 게시글 제목, 댓글 내용, 댓글 작성자 리스트

                                    commentController.text = '';

                                    //checkCountedCommentWriterList 업데이트
                                    checkCountedCommentWriterList();
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: commmentButtonolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12.0), // 둥근 테두리 설정
                                ),
                              ),
                              child: Text(
                                languageController.communityCommentRegistration,
                                style: TextStyle(
                                  color: mainTextColor,
                                  letterSpacing: 1.w,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  postReport() {
    showDialog(
      context: context,
      builder: (context) {
        //AlertDialog는 StateLess라서 setState가 안먹음. 따라서 StatefulBuilder로 감싸줌.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SizedBox(
                height: 350.h,
                width: 500.w,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(languageController.postReport,
                        style: TextStyle(
                          fontFamily: "Neo",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        )),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: reportController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text(
                              languageController.reportReasonPlaceholder,
                              style: TextStyle(
                                fontFamily: "Inter",
                                //fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                // 여기서 DB 연결 !!!

                                // await reportSave(
                                //     postController.post.postTitle,
                                //     postController.post.postNum.toString(),
                                //     postController.post.postContent,
                                //     reportController.text,
                                //     postController.post.postWriter,
                                //     token!);

                                //이러면 showDialog가 pop될걸?
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Future.delayed(
                                      Duration(seconds: 1),
                                      () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                    );
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 400.w,
                                        height: 120.h,
                                        child: Center(
                                          child: Text(
                                            languageController
                                                .reportCompletedMessage,
                                            style: TextStyle(
                                                color: mainTextColor,
                                                letterSpacing: 1.w,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.sp),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                reportController.text = "";
                              },
                              child: Text(
                                languageController.postReport,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  modifyContent() {
    //컨트롤러에 게시글 내용 옮겨놓기
    contentController.text = postController.post.postContent;

    showDialog(
      context: context,
      builder: (context) {
        //AlertDialog는 StateLess라서 setState가 안먹음. 따라서 StatefulBuilder로 감싸줌.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SizedBox(
                height: 350.h,
                width: 500.w,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(languageController.postEdit,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        )),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Container(
                        height: 200.h,
                        child: TextField(
                          controller: contentController,
                          maxLines: 6,
                          maxLength: 200,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text(
                              languageController.postEditContentPlaceholder,
                              style: TextStyle(
                                fontFamily: "Inter",
                                //fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                // 여기서 DB 연결 !!!

                                postController.post.postContent =
                                    contentController.text;

                                fb_modify_post(
                                    postController.post.postTitle,
                                    postController.post.postNum,
                                    postController.post.postContent);

                                //이러면 showDialog가 pop될걸?
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                contentController.text = "";

                                //끝나고 새로고침 한 번!
                                // Navigator.pop(context);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => WrittenPostPage(
                                //         postController.post,
                                //         postController.index),
                                //   ),
                                // );
                              },
                              child: Text(
                                languageController.postEditCompletedMessage,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  deletePost() {
    showDialog(
      context: context,
      builder: (context) {
        //AlertDialog는 StateLess라서 setState가 안먹음. 따라서 StatefulBuilder로 감싸줌.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SizedBox(
                height: 250.h,
                width: 350.w,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(languageController.postDelete,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        )),
                    SizedBox(height: 10.h),
                    Text(languageController.postDeleteConfirmation,
                        style: TextStyle(
                          fontFamily: "Inter",
                          //fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        )),
                    SizedBox(height: 20.h),
                    Text(
                        languageController.postTitleLabel +
                            postController.post.postTitle,
                        style: TextStyle(
                          fontFamily: "Inter",
                          //fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        )),
                    SizedBox(height: 40.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                // 여기서 DB 연결 !!!

                                //전체 게시글 목록에서도 삭제
                                postListController
                                    .deletePostList(postController.post);

                                fb_delete_post(postController.post.postNum,
                                    postListController.postList);

                                //이러면 showDialog가 pop될걸?
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                //새로고침을 위하여 기존 화면 스택을 날리고 다시 시작함
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (_) => false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommunityScreen()),
                                );
                              },
                              child: Text(
                                languageController.communityWrittenPostDelete,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                //이러면 showDialog가 pop될걸?
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: Text(
                                languageController.cancel,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  deleteComment(int commentIndex) {
    showDialog(
      context: context,
      builder: (context) {
        //AlertDialog는 StateLess라서 setState가 안먹음. 따라서 StatefulBuilder로 감싸줌.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SizedBox(
                height: 200.h,
                width: 350.w,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(languageController.commentDelete,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        )),
                    SizedBox(height: 10.h),
                    Text(languageController.postDeleteConfirmation,
                        style: TextStyle(
                          fontFamily: "Inter",
                          //fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        )),
                    SizedBox(height: 20.h),
                    // Text(
                    //     '내용 : ' + postController.post.commentList[commentIndex],
                    //     style: TextStyle(
                    //       fontFamily: "Neo",
                    //       //fontWeight: FontWeight.bold,
                    //       fontSize: 12.sp,
                    //     )),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  postController.post.commentWriterList
                                      .removeAt(commentIndex);
                                  postController.post.commentList
                                      .removeAt(commentIndex);

                                  fb_delete_comment(
                                      postController.post.postNum,
                                      postController.post.commentList,
                                      postController.post
                                          .commentWriterList); // 댓글 추가 - 게시글 제목, 댓글 내용, 댓글 작성자 리스트

                                  //checkCountedCommentWriterList 업데이트
                                  checkCountedCommentWriterList();
                                });

                                //이러면 showDialog가 pop될걸?
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                //새로고침을 위하여 기존 화면 스택을 날리고 다시 시작함
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (_) => false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommunityScreen()),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WrittenPostPage(
                                        postController.post,
                                        postController.index),
                                  ),
                                );
                              },
                              child: Text(
                                languageController.communityWrittenPostDelete,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                //이러면 showDialog가 pop될걸?
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: Text(
                                languageController.cancel,
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
