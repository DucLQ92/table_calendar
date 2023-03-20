// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../customization/calendar_builders.dart';
import '../customization/calendar_style.dart';

class CellContent extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final dynamic locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isWithinRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isHoliday;
  final bool isWeekend;
  final bool isSophie;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;
  final List Function(DateTime day)? eventLoader;

  const CellContent({
    Key? key,
    required this.day,
    required this.focusedDay,
    required this.calendarStyle,
    required this.calendarBuilders,
    required this.isTodayHighlighted,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isWithinRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isHoliday,
    required this.isWeekend,
    required this.isSophie,
    required this.eventLoader,
    this.locale,
  }) : super(key: key);

  Widget _buildItemEvent(String name, bool isOn, bool isBooked) {
    return isOn
        ? Stack(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFF1A9CC6),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 2.0),
                margin: EdgeInsets.symmetric(vertical: 1.0),
                child: Text(
                  name,
                  style: calendarStyle.textStyleEventSophie01,
                ),
              ),
              isBooked
                  ? Positioned(
                      top: 3.0,
                      right: 2.0,
                      child: Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFF44067),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            margin: EdgeInsets.symmetric(vertical: 1.0),
            child: Text(
              '',
              style: calendarStyle.textStyleEventSophie01,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(locale).format(day);
    final dayLabel = DateFormat.yMMMMd(locale).format(day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell = calendarBuilders.prioritizedBuilder?.call(context, day, focusedDay);

    if (cell != null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      );
    }

    final text = '${day.day}';
    final margin = calendarStyle.cellMargin;
    final padding = calendarStyle.cellPadding;
    final alignment = calendarStyle.cellAlignment;
    final duration = const Duration(milliseconds: 250);

    if (isDisabled) {
      cell = calendarBuilders.disabledBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.disabledDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.disabledTextStyle),
          );
    } else if (isSelected) {
      cell = calendarBuilders.selectedBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.selectedDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.selectedTextStyle),
          );
    } else if (isRangeStart) {
      cell = calendarBuilders.rangeStartBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeStartDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeStartTextStyle),
          );
    } else if (isRangeEnd) {
      cell = calendarBuilders.rangeEndBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.rangeEndDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeEndTextStyle),
          );
    } else if (isToday && isTodayHighlighted) {
      cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.todayDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.todayTextStyle),
          );
    } else if (isHoliday) {
      cell = calendarBuilders.holidayBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.holidayDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.holidayTextStyle),
          );
    } else if (isWithinRange) {
      cell = calendarBuilders.withinRangeBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.withinRangeDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.withinRangeTextStyle),
          );
    } else if (isOutside) {
      cell = calendarBuilders.outsideBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: calendarStyle.outsideDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.outsideTextStyle),
          );
    } else {
      cell = calendarBuilders.defaultBuilder?.call(context, day, focusedDay) ??
          AnimatedContainer(
            duration: duration,
            margin: margin,
            padding: padding,
            decoration: isWeekend ? calendarStyle.weekendDecoration : calendarStyle.defaultDecoration,
            alignment: alignment,
            child: Text(
              text,
              style: isWeekend ? calendarStyle.weekendTextStyle : calendarStyle.defaultTextStyle,
            ),
          );
    }

    List events = [];
    if (isSophie) {
      events = eventLoader?.call(day) ?? [];
    }

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: isSophie
          ? !isOutside
              ? Column(
                  children: [
                    cell,
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              events.isNotEmpty
                                  ? _buildItemEvent(events.first.isMorningName, events.first.isOnMorning,
                                      events.first.isBookedMorning)
                                  : const SizedBox.shrink(),
                              events.isNotEmpty
                                  ? _buildItemEvent(events.first.isAfternoonName, events.first.isOnAfternoon,
                                      events.first.isBookedAfternoon)
                                  : const SizedBox.shrink(),
                              events.isNotEmpty
                                  ? _buildItemEvent(events.first.isEveningName, events.first.isOnEvening,
                                      events.first.isBookedEvening)
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cell,
                  ],
                )
          : cell,
    );
  }
}
