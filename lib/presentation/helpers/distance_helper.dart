
String formatDistance(double? distanceFromUser) {
  if (distanceFromUser == null) {
    return '0 km'; // If distanceFromUser is null, return '0 km'
  }

  if (distanceFromUser > 100) {
    return '>100 km'; // If the distance is greater than 100 km, return '> 100 km'
  }

  // If distance is less than 1 km, show it with 3 decimal places and 'm'. Otherwise, show it in 'km'.
  return (distanceFromUser < 1)
      ? '${distanceFromUser.toStringAsFixed(3)} m'
      : '${distanceFromUser.toStringAsFixed(0)} km';
}