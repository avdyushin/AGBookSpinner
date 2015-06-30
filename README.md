# AGBookSpinner

![Demo1](AGBookSpinner1.gif)
![Demo2](AGBookSpinner2.gif)

Custom spinner demo using `CABasicAnimation` to animate drawing of `UIBezierPath`.

You can learn how to:

* Draw path via `UIBezierPath`
* Combine multiple paths into one
* Animate the drawing
* Pause and resume animations

This project can be used as start point template project to create your custom spinner.

Usage example:

```
spinner.hidesWhenStopped = YES;
spinner.tintColor = [UIColor redColor];
...
if (spinner.isAnimating) {
    [spinner stopAnimating];
} else {
    [spinner startAnimating];
}
```
