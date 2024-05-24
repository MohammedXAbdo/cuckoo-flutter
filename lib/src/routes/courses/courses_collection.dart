import 'package:auto_size_text/auto_size_text.dart';
import 'package:cuckoo/src/common/extensions/extensions.dart';
import 'package:cuckoo/src/common/services/moodle.dart';
import 'package:cuckoo/src/common/ui/ui.dart';
import 'package:cuckoo/src/models/index.dart';
import 'package:cuckoo/src/routes/courses/course_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const double kSpacingBetweenCourseTiles = 18.0;
const double kSpacingBetweenCourseRows = 20.0;
const double kCourseTileHeight = 140.0;
const double kCourseTileMaxWidth = 200.0;
const double kCourseTileMinWidth = 150.0;

class MoodleCourseCollectionView extends StatefulWidget {
  const MoodleCourseCollectionView({super.key, required this.showFavoriteOnly});

  /// Only show favorite courses.
  final bool showFavoriteOnly;

  @override
  State<MoodleCourseCollectionView> createState() =>
      _MoodleCourseCollectionViewState();
}

class _MoodleCourseCollectionViewState
    extends State<MoodleCourseCollectionView> {
  late List<MoodleCourse> courses;

  List<Widget> _courseTiles(double tileWidth) {
    return courses.map((course) {
      return SizedBox(
        width: tileWidth,
        height: kCourseTileHeight,
        child: MoodleCourseTile(course),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to course changes
    courses = context.courseManager
        .sortedCourses(showFavoriteOnly: widget.showFavoriteOnly);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int coursesPerRow =
                (constraints.maxWidth / kCourseTileMinWidth).floor();
            double tileWidth =
                (constraints.maxWidth - kSpacingBetweenCourseTiles) /
                    coursesPerRow;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15.0),
                Wrap(
                  spacing: kSpacingBetweenCourseTiles,
                  runSpacing: kSpacingBetweenCourseRows,
                  children: _courseTiles(tileWidth),
                ),
                const SizedBox(height: 20.0),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MoodleCourseTile extends StatelessWidget {
  const MoodleCourseTile(this.course, {super.key});

  final MoodleCourse course;

  /// Icon of the course to show at the background.
  IconData _courseIcon() {
    const iconsToUse = [
      FontAwesomeIcons.gamepad,
      FontAwesomeIcons.school,
      FontAwesomeIcons.pen,
      FontAwesomeIcons.paw,
      FontAwesomeIcons.chartSimple,
      FontAwesomeIcons.chartPie,
      FontAwesomeIcons.flask,
      FontAwesomeIcons.compass,
      FontAwesomeIcons.palette,
      FontAwesomeIcons.atom,
      FontAwesomeIcons.dna,
      FontAwesomeIcons.bookOpen,
      FontAwesomeIcons.graduationCap,
      FontAwesomeIcons.book,
      FontAwesomeIcons.brain,
      FontAwesomeIcons.scroll,
      FontAwesomeIcons.buildingColumns,
      FontAwesomeIcons.ruler,
      FontAwesomeIcons.globe,
      FontAwesomeIcons.seedling,
    ];
    return iconsToUse[course.id.toInt() % iconsToUse.length];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CourseDetailPage(course),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [course.color, course.color.withAlpha(220)])),
          child: Stack(
            children: [
              Positioned(
                top: -15,
                right: -5,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(
                    child: FaIcon(
                      _courseIcon(),
                      color: Colors.black.withAlpha(12),
                      size: 80,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  // Course code
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 12.0),
                    child: AutoSizeText(
                      course.courseCode,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStylePresets.title(
                              size: 18.5, weight: FontWeight.w600)
                          .copyWith(color: Colors.white, height: 1.05),
                    ),
                  ),
                  // Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 8.0),
                    color: context.cuckooTheme.primaryInverseText
                        .withAlpha(context.isDarkMode ? 140 : 180),
                    child: Text(
                      course.nameWithoutCode,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStylePresets.body(
                              size: 13, weight: FontWeight.w500)
                          .copyWith(height: 1.4),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
