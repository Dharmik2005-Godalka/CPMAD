import 'package:campus_connect/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() 
{
  test('returns the text for each language', () 
  {
    expect(const AppStrings(Locale('en')).events, 'Events');
    expect(const AppStrings(Locale('hi')).events, 'कार्यक्रम');
    expect(const AppStrings(Locale('gu')).events, 'કાર્યક્રમો');
  });

  test('falls back to English for an unknown language', () 
  {
    expect(const AppStrings(Locale('fr')).events, 'Events');
  });

  test('goingCount fills in the number', () 
  {
    expect(const AppStrings(Locale('en')).goingCount(5), '5 going');
  });
}
