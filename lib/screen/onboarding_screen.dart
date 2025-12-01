import 'package:flutter/material.dart';

import '../model/enum.dart';
import '../model/screen_data_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int _index = 0; // current screen index

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // start auto-play after a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runSequence();
    });
  }

  // ---------------------------------------------------------------------------
  // DATA
  // ---------------------------------------------------------------------------

  final List<ScreenDataModel> screens = [
    // 0 - first: plain green
    ScreenDataModel(
      color: const Color(0xFF27AE60),
      type: ScreenType.plain,
      main: '',
    ),

    // 1 - question (green)
    ScreenDataModel(
      color: const Color(0xFF27AE60),
      type: ScreenType.question,
      main: 'How much\nof my earnings\ndo I get to keep?',
    ),

    // 2 - answer (green)
    ScreenDataModel(
      color: const Color(0xFF27AE60),
      type: ScreenType.answer,
      main: '100%.',
      body: 'We charge zero\ncommission on\nyour sales.',
    ),

    // 3 - question (blue)
    ScreenDataModel(
      color: const Color(0xFF2980B9),
      type: ScreenType.question,
      main: 'Will I get paid\non time,\nand is it safe?',
      showSkip: true,
    ),

    // 4 - answer (blue)
    ScreenDataModel(
      color: const Color(0xFF2980B9),
      type: ScreenType.answer,
      main: 'Always',
      body: 'Payments are\nsecure and\non-time,\nevery time.',
      showSkip: true,
    ),

    // 5 - question (purple)
    ScreenDataModel(
      color: const Color(0xFF9B59B6),
      type: ScreenType.question,
      main: 'Can I reach more\ncustomers beyond\nmy area?',
      showSkip: true,
    ),

    // 6 - answer (purple)
    ScreenDataModel(
      color: const Color(0xFF9B59B6),
      type: ScreenType.answer,
      main: 'Yes!',
      body: 'We deliver to\n20,000+ pin codes\nacross India.',
      showSkip: true,
    ),

    // 7 - question (orange)
    ScreenDataModel(
      color: const Color(0xFFE67E22),
      type: ScreenType.question,
      main: 'What if most of my\nsales happen offline?',
      showSkip: true,
    ),

    // 8 - answer (orange)
    ScreenDataModel(
      color: const Color(0xFFE67E22),
      type: ScreenType.answer,
      main: 'No worries',
      body: 'offline exposure is\npart of the plan.',
      showSkip: true,
    ),

    // 9 - question (red)
    ScreenDataModel(
      color: const Color(0xFFE74C3C),
      type: ScreenType.question,
      main: 'How do I minimize \nreturns and losses?',
      showSkip: true,
    ),

    // 10 - answer (red)
    ScreenDataModel(
      color: const Color(0xFFE74C3C),
      type: ScreenType.answer,
      main: 'With us,',
      body: 'you get fewer\nreturns and\nmore profit.',
      showSkip: true,
    ),
  ];

  // ---------------------------------------------------------------------------
  // AUTO ANIMATION
  // ---------------------------------------------------------------------------

  Future<void> _runSequence() async {
    // show plain green for a moment
    await Future.delayed(const Duration(milliseconds: 600));

    while (mounted && _index < screens.length - 1) {
      setState(() {
        _index++; // move to next screen
      });

      _controller.reset();
      _controller.forward();

      // keep each screen visible for a bit
      await Future.delayed(const Duration(milliseconds: 2200));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final current = screens[_index];

    return Scaffold(
      backgroundColor: current.color,
      body: SafeArea(
        child: Stack(
          children: [
            // OLD QUESTION TEXT (for answer screens only)
            if (current.type == ScreenType.answer) _buildOldQuestion(),

            // CURRENT TEXT
            if (current.type == ScreenType.question)
              _buildQuestionFromBottom(current)
            else if (current.type == ScreenType.answer)
              _buildAnswerFromRight(current),

            // SKIP BUTTON (from blue screens onwards)
            if (current.showSkip) _buildSkipButton(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGETS
  // ---------------------------------------------------------------------------

  // previous screen text (question) moves slightly up and fades grey
  Widget _buildOldQuestion() {
    final prev = screens[_index - 1];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double upOffset = _controller.value * 50.0;

        return Positioned(
          left: 24,
          right: 24,
          top: 180 - upOffset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prev.main,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: Colors.black,
                ),
              ),
              if (prev.body != null && prev.body!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  prev.body!,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // question screen: text from bottom → center
  Widget _buildQuestionFromBottom(ScreenDataModel data) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double offsetY = (1 - _controller.value) * 120.0;

        return Positioned(
          left: 24,
          right: 24,
          top: 240 + offsetY,
          child: Opacity(
            opacity: _controller.value,
            child: Text(
              data.main,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  // answer screen: title from right → place below old text
  Widget _buildAnswerFromRight(ScreenDataModel data) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double offsetX = (1 - _controller.value) * 200.0;

        return Positioned(
          left: 30 + offsetX,
          right: 30,
          top: 240,
          child: Opacity(
            opacity: _controller.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // big heading (100%, Always, Yes!, No worries, With us,)
                Text(
                  data.main,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                if (data.body != null && data.body!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    data.body!,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
