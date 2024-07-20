import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// three dates (initial, first and last) are required
/// initialDate: initial date from which you want to start
///               should be in bewtween firstDate and lastDate
/// firstDate: date from which you want to start
///             should not be before lastDate
/// lastDate: date where you want to stop
///
Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return _MonthPicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    },
  );
}

class _MonthPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _MonthPicker({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  State<_MonthPicker> createState() => __MonthPickerState();
}

class __MonthPickerState extends State<_MonthPicker> {
  final _pageViewKey = GlobalKey();
  late final PageController _pageController;
  late int _displayedPage;
  late DateTime _selectedDate;
  bool _isYearSelection = false;
  late final DateTime _firstDate;
  late final DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(widget.firstDate.year, widget.firstDate.month);
    _lastDate = DateTime(widget.lastDate.year, widget.lastDate.month);
    _selectedDate = DateTime(widget.initialDate.year, widget.initialDate.month);
    _displayedPage = _selectedDate.year;
    _pageController = PageController(initialPage: _displayedPage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pager = _buildPager(theme.colorScheme);

    final content = Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Column(
        children: [
          pager,
          Container(height: 24.0),
          _buildButtonBar(context),
        ],
      ),
    );
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) {
              return MediaQuery.of(context).orientation == Orientation.portrait
                  ? IntrinsicWidth(
                      child: Column(
                      children: [
                        IntrinsicHeight(
                          child: _buildHeader(theme),
                        ),
                        const SizedBox(height: 8.0),
                        content,
                      ],
                    ))
                  : IntrinsicHeight(
                      child: Row(children: [
                        _buildHeader(theme),
                        const SizedBox(width: 8.0),
                        content,
                      ]),
                    );
            },
          ),
        ],
      ),
    );
  }

  _buildHeader(ThemeData theme) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text(
                DateFormat.yMMM().format(_selectedDate),
                style: theme.primaryTextTheme.subtitle1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: theme.primaryIconTheme.color,
                  ),
                  onPressed: () => _pageController.animateToPage(
                    _displayedPage - 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
                ),
                DefaultTextStyle(
                  style: theme.primaryTextTheme.headline5!,
                  child: (_isYearSelection)
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(DateFormat.y().format(
                              DateTime(_displayedPage * 12),
                            )),
                            const Text(' - '),
                            Text(DateFormat.y().format(
                              DateTime(_displayedPage * 12 + 11),
                            )),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() => _isYearSelection = true);
                            _pageController.jumpToPage(_displayedPage ~/ 12);
                          },
                          child: Text(
                            DateFormat.y().format(DateTime(_displayedPage)),
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                    color: theme.primaryIconTheme.color,
                  ),
                  onPressed: () => _pageController.animateToPage(
                    _displayedPage + 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildPager(ColorScheme colorScheme) {
    return SizedBox(
      height: 220,
      width: 300,
      child: PageView.builder(
        key: _pageViewKey,
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) => setState(() => _displayedPage = index),
        pageSnapping: !_isYearSelection,
        itemBuilder: (context, page) {
          return GridView.count(
            crossAxisCount: 4,
            padding: const EdgeInsets.all(12.0),
            physics: const NeverScrollableScrollPhysics(),
            children: _isYearSelection
                ? List<int>.generate(12, (i) => page * 12 + i)
                    .map(
                      (year) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getYearButton(year, colorScheme),
                      ),
                    )
                    .toList()
                : List<int>.generate(12, (i) => i + 1)
                    .map((month) => DateTime(page, month))
                    .map(
                      (date) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getMonthButton(date, colorScheme),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }

  _getYearButton(int year, ColorScheme colorScheme) {
    bool isSelected = year == _selectedDate.year;
    return TextButton(
      onPressed: () => setState(
        () {
          _pageController.jumpToPage(year);
          setState(() => _isYearSelection = false);
        },
      ),
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).colorScheme.primary : null,
        // primary: isSelected
        //     ? colorScheme.onPrimary
        //     : year == DateTime.now().year
        //         ? Colors.blue
        //         : colorScheme.onSurface.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Text(
        DateFormat.y().format(DateTime(year)),
      ),
    );
  }

  _getMonthButton(DateTime date, ColorScheme colorScheme) {
    bool isSelected =
        date.month == _selectedDate.month && date.year == _selectedDate.year;
    final int isFirstDate = _firstDate.compareTo(date);
    final int isLastDate = _lastDate.compareTo(date);

    VoidCallback? callback = (isFirstDate <= 0) && (isLastDate >= 0)
        ? () => setState(() => _selectedDate = DateTime(date.year, date.month))
        : null;
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        backgroundColor: !isSelected
            ? colorScheme.onPrimary
            : colorScheme.primary.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Text(
        DateFormat.MMM().format(date).toUpperCase(),
      ),
    );
  }

  _buildButtonBar(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return ButtonTheme(
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(localizations.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedDate),
            child: Text(localizations.okButtonLabel),
          ),
        ],
      ),
    );
  }
}
