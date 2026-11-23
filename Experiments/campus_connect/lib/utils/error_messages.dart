import 'package:cloud_firestore/cloud_firestore.dart';

String friendlyError(Object error) 
{
  if (error is FirebaseException) 
  {
    switch (error.code) 
    {
      case 'permission-denied':
        return 'You do not have permission to see this data. Please log out and log in again.';
      case 'unauthenticated':
        return 'Your session has expired. Please log in again.';
      case 'unavailable':
        return 'No internet connection. Please check your network and try again.';
      case 'deadline-exceeded':
        return 'The server took too long to respond. Please try again.';
      case 'not-found':
        return 'This item no longer exists.';
    }
  }
  return 'Something went wrong. Please try again.';
}
