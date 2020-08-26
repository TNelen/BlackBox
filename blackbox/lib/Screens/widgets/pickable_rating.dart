import 'package:flutter/material.dart';

class PickableRating extends StatefulWidget {
  
  final double size;
  final void Function(int rating) onTap;
  final int defaultRating;

  PickableRating({this.size: 25.0, this.onTap, int startRating: 0}) : defaultRating = startRating;

  @override
  State<StatefulWidget> createState() {
    return _PickableRatingState();
  }

}

class _PickableRatingState extends State<PickableRating> {

  int rating;

  void initState()
  {
    super.initState();
    rating = widget.defaultRating;
  }

  /// Build a star Widget based on its index in the row [1, 5] will be filled or not
  Widget buildStar(int index)
  {
    return IconButton(
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        size: widget.size,
        color: Colors.yellow,
      ), 
      onPressed: () => {

        // Change the look of the stars
        setState( () {
          // Update rating
          rating != index ? rating = index : rating = 0;
          
          // Perform callback
          if (widget.onTap != null)
            widget.onTap( rating );
        }),
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    // Create list of stars
    final List<Widget> stars = List<Widget>();
    for (int i = 1; i <= 5; i++)
      stars.add(buildStar( i ));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }
  
}