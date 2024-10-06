# Weelorum Swift Style Guide

* [Objective-C](https://github.com/Weelorum/Weelorum-Objective-C-Style-Guide)
* [Kotlin](https://github.com/Weelorum/Weelorum-Kotlin-Style-Guide)
* [Java](https://github.com/Weelorum/Weelorum-Java-Style-Guide)

## Table of Contents

* [Correctness](#correctness)
* [Naming](#naming)
  * [Prose](#prose)
  * [Delegates](#delegates)
  * [Use Type Inferred Context](#use-type-inferred-context)
  * [Generics](#generics)
  * [Class Prefixes](#class-prefixes)
  * [Language](#language)
* [Code Organization](#code-organization)
  * [Protocol Conformance](#protocol-conformance)
  * [Unused Code](#unused-code)
  * [Minimal Imports](#minimal-imports)
* [Spacing](#spacing)
* [Comments](#comments)
* [Classes and Structures](#classes-and-structures)
  * [Use of Self](#use-of-self)
  * [Protocol Conformance](#protocol-conformance)
  * [Computed Properties](#computed-properties)
  * [Final](#final)
* [Function Declarations](#function-declarations)
* [Closure Expressions](#closure-expressions)
* [Types](#types)
  * [Fonts and Colors](#fonts-and-colors)
  * [Constants](#constants)
  * [Static Methods and Variable Type Properties](#static-methods-and-variable-type-properties)
  * [Optionals](#optionals)
  * [Lazy Initialization](#lazy-initialization)
  * [Type Inference](#type-inference)
  * [Syntactic Sugar](#syntactic-sugar)
* [Functions vs Methods](#functions-vs-methods)
* [Memory Management](#memory-management)
  * [Extending Lifetime](#extending-lifetime)
* [Access Control](#access-control)
* [Control Flow](#control-flow)
* [Golden Path](#golden-path)
  * [Failing Guards](#failing-guards)
* [Semicolons](#semicolons)
* [Parentheses](#parentheses)
* [No Emoji](###no-Emoji)
* [Organization and Bundle Identifier](#organization-and-bundle-identifier)
* [Documentation](#documentation)
* [Compile and Dependencies](#compile-and-dependencies)
* [Distribution](#distribution)
* [Localization](#localization)
* [AboutWeelorum](#about-weelorum)


## Correctness

Aim to ensure your code compiles without any warnings. This principle influences several style choices, such as preferring `#selector` types over string literals to reduce the likelihood of runtime errors. Additionally, always validate your code for unused variables, deprecated APIs, and potential logical errors to enhance maintainability and reliability.

## Naming

Descriptive and consistent naming makes software easier to read and understand. Use the Swift naming conventions described in the [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Key principles include:

- Strive for clarity at the call site and prioritize it over brevity.
- Use camel case for identifiers; capitalize types and protocols, while using lowercase for others.
- Include all necessary words, omitting the needless ones.
- Name based on roles, not types, and compensate for weak type information when needed.
- Ensure fluent usage in method calls.
- Use specific prefixes for factory methods, e.g., `make`
- Name methods according to their side effects:
  - Non-mutating verb methods should follow the -ed or -ing rule.
  - Mutating noun methods should follow the formX rule.
  - Boolean types should read like assertions.
  - Protocols that describe _a capability_ should end in _-able_ or _-ible_
- Avoid surprising experts or confusing beginners with terminology.
- Generally, avoid abbreviations and use established precedents for naming.
- Prefer methods and properties over free functions.
- Ensure uniform casing for acronyms and initialisms.
- Use the same base name for methods with shared meanings, avoiding overloads based solely on return types.
- Choose descriptive parameter names that act as documentation, label closure and tuple parameters, and utilize default parameters effectively.

### Prose

When referring to methods in prose, being unambiguous is critical. To refer to a method name, use the simplest form possible.

1. Method Name without Parameters: Use this format for clarity.  **Example:** Next, you need to call the method `addTarget`.
2. Method Name with Argument Labels: Include argument labels for specificity..  **Example:** Next, you need to call the method `addTarget(_:action:)`.
3. Full Method Name with Argument Labels and Types: Provide full detail if necessary. **Example:** Next, you need to call the method `addTarget(_: Any?, action: Selector?)`.

For the example using UIGestureRecognizer, the first option is preferred for its unambiguity.

**Pro Tip:** You can use Xcode's jump bar to lookup methods with argument labels.

![Methods in Xcode jump bar](screens/xcode-jump-bar.png)


### Class Prefixes

Class Prefixes
Swift types are automatically namespaced by their containing module, so adding class prefixes (e.g., MM) is unnecessary. If name collisions occur between types from different modules, disambiguate by prefixing the type name with the module name, but only when confusion is likely, which should be rare.

```swift
import SomeModule

let myClass = MyModule.UsefulClass()
```

### Delegates

When creating custom delegate methods, an unnamed first parameter should be the delegate source. (UIKit contains numerous examples of this.)

**Preferred:**
```swift
func namePickerView(_ namePickerView: NamePickerView, didSelectName name: String)
func namePickerViewShouldReload(_ namePickerView: NamePickerView) -> Bool
```

**Not Preferred:**
```swift
func didSelectName(namePicker: NamePickerViewController, name: String)
func namePickerShouldReload() -> Bool
```

### Use Type Inferred Context

Use compiler inferred context to write shorter, clear code.  (Also see [Type Inference](#type-inference).)

**Preferred:**
```swift
let selector = #selector(viewDidLoad)
view.backgroundColor = .red
let toView = context.view(forKey: .to)
let view = UIView(frame: .zero)
```

**Not Preferred:**
```swift
let selector = #selector(ViewController.viewDidLoad)
view.backgroundColor = UIColor.red
let toView = context.view(forKey: UITransitionContextViewKey.to)
let view = UIView(frame: CGRect.zero)
```

### Generics

Generic type parameters should be descriptive, upper camel case names. When a type name doesn't have a meaningful relationship or role, use a traditional single uppercase letter such as `T`, `U`, or `V`.

**Preferred:**
```swift
struct Stack<Element> { ... }
func write<Target: OutputStream>(to target: inout Target)
func swap<T>(_ a: inout T, _ b: inout T)
```

**Not Preferred:**
```swift
struct Stack<T> { ... }
func write<target: OutputStream>(to target: inout target)
func swap<Thing>(_ a: inout Thing, _ b: inout Thing)
```

### Language

Use US English spelling throughout your codebase to maintain consistency with Apple's API and documentation. This practice enhances readability and ensures alignment with common conventions within the Swift programming community.

**Preferred:**
```swift
let color = "red"
```

**Not Preferred:**
```swift
let colour = "red"
```

## Code Organization

Use extensions to organize your code into logical blocks of functionality. Each extension should be set off with a `// MARK: -` comment to keep things well-organized.
**Preferred:**
```swift
//MARK: - Class Methods
//MARK: - Lifecycle Object
//MARK: - Methods
//MARK: - Actions
//MARK: - ProtocolName
//MARK: - DelegateName
```
**Example:**
```swift
// MARK: - Initializers
extension MyClass {
    init() {
        // Initialization code
    }
}
```
**Example:**
```swift
// MARK: - Public Methods
extension MyClass {
    func publicMethod() {
        // Method implementation
    }
}
```

### Protocol Conformance

In particular, when adding protocol conformance to a model, prefer adding a separate extension for the protocol methods. This keeps the related methods grouped together with the protocol and can simplify instructions to add a protocol to a class with its associated methods.

**Preferred:**
```swift
class MyViewController: UIViewController {
  // class stuff here
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
  // table view data source methods
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
  // scroll view delegate methods
}
```

**Not Preferred:**
```swift
class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // all methods
}
```

Since the compiler does not allow you to re-declare protocol conformance in a derived class, it is not always required to replicate the extension groups of the base class. This is especially true if the derived class is a terminal class and a small number of methods are being overridden. When to preserve the extension groups is left to the discretion of the author.

For UIKit view controllers, consider grouping lifecycle, custom accessors, and view configuration in separate class extensions.

### Unused Code

Unused (dead) code, including Xcode template code and placeholder comments should be removed. An exception is when your tutorial or book instructs the user to use the commented code.

Aspirational methods not directly associated with the tutorial whose implementation simply calls the superclass should also be removed. This includes any empty/unused UIApplicationDelegate methods.

**Preferred:**
```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return Database.contacts.count
}
```

**Not Preferred:**
```swift
override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
}

override func numberOfSections(in tableView: UITableView) -> Int {
  // #warning Incomplete implementation, return the number of sections
  return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  // #warning Incomplete implementation, return the number of rows
  return Database.contacts.count
}

```
### Minimal Imports

Keep imports minimal. For example, don't import `UIKit` when importing `Foundation` will suffice. If you use some module in the whole project, transfer this one to header files.

## Spacing

* Indent using 2 spaces rather than tabs to conserve space and help prevent line wrapping. Be sure to set this preference in Xcode and in the Project settings as shown below:

![Xcode indent settings](screens/indentation.png)

* Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.
* Tip: You can re-indent by selecting some code (or ⌘A to select all) and then Control-I (or Editor\Structure\Re-Indent in the menu). Some of the Xcode template code will have 4-space tabs hard coded, so this is a good way to fix that.

**Preferred:**
```swift
if user.isHappy { // 1 line } 
else { // 1 line }

if user.isHappy { 
 // 1 line 
 // 2 line
} else {
  // 1 line 
  // 2 line
}

```

**Not Preferred:**
```swift
if user.isHappy
{
  // Do something
 }
else {
  // Do something else
 }
```

* There should be exactly one blank line between methods to aid in visual clarity and organization. Whitespace within methods should separate functionality, but having too many sections in a method often means you should refactor into several methods.

* Colons always have no space on the left and one space on the right. Exceptions are the ternary operator `? :`, empty dictionary `[:]` and `#selector` syntax for unnamed parameters `(_:)`.

**Preferred:**
```swift
class TestDatabase: Database {
  var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
}
```

**Not Preferred:**
```swift
class TestDatabase : Database {
  var data :[String:CGFloat] = ["A" : 1.2, "B":3.2]
}
```

* Long lines should be wrapped at around 70 characters. A hard limit is intentionally not specified.

* Avoid trailing whitespaces at the ends of lines.

* Add a single newline character at the end of each file.

## Comments

When they are needed, use comments to explain **why** a particular piece of code does something. Comments must be kept up-to-date or deleted.

Avoid block comments inline with code, as the code should be as self-documenting as possible. *Exception: This does not apply to those comments used to generate documentation.*


## Classes and Structures

### Which one to use?

Remember, structs have [value semantics](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_144). Use structs for things that do not have an identity. An array that contains [a, b, c] is really the same as another array that contains [a, b, c] and they are completely interchangeable. It doesn't matter whether you use the first array or the second, because they represent the exact same thing. That's why arrays are structs.

Classes have [reference semantics](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html#//apple_ref/doc/uid/TP40014097-CH13-XID_145). Use classes for things that do have an identity or a specific life cycle. You would model a person as a class because two person objects are two different things. Just because two people have the same name and birthdate, doesn't mean they are the same person. But the person's birthdate would be a struct because a date of 3 March 1950 is the same as any other date object for 3 March 1950. The date itself doesn't have an identity.

Sometimes, things should be structs but need to conform to `AnyObject` or are historically modeled as classes already (`NSDate`, `NSSet`). Try to follow these guidelines as closely as possible.

### Example definition

Here's an example of a well-styled class definition:

```swift
class Circle: Shape {
  var x: Int, y: Int
  var radius: Double
  var diameter: Double {
    get {
      return radius * 2
    }
    set {
      radius = newValue / 2
    }
  }

  init(x: Int, y: Int, radius: Double) {
    self.x = x
    self.y = y
    self.radius = radius
  }

  convenience init(x: Int, y: Int, diameter: Double) {
    self.init(x: x, y: y, radius: diameter / 2)
  }

  override func area() -> Double {
    return Double.pi * radius * radius
  }
}

extension Circle: CustomStringConvertible {
  var description: String {
    return "center = \(centerString) area = \(area())"
  }
  private var centerString: String {
    return "(\(x),\(y))"
  }
}
```

The example above demonstrates the following style guidelines:

 + Specify types for properties, variables, constants, argument declarations and other statements with a space after the colon but not before, e.g. `x: Int`, and `Circle: Shape`.
 + Define multiple variables and structures on a single line if they share a common purpose / context.
 + Indent getter and setter definitions and property observers.
 + Don't add modifiers such as `internal` when they're already the default. Similarly, don't repeat the access modifier when overriding a method.
 + Organize extra functionality (e.g. printing) in extensions.
 + Hide non-shared, implementation details such as `centerString` inside the extension using `private` access control.

### Use of Self

For conciseness, avoid using `self` since Swift does not require it to access an object's properties or invoke its methods.

Use self only when required by the compiler (in `@escaping` closures, or in initializers to disambiguate properties from arguments). In other words, if it compiles without `self` then omit it.


### Computed Properties

For conciseness, if a computed property is read-only, omit the get clause. The get clause is required only when a set clause is provided.

**Preferred:**
```swift
var diameter: Double { return radius * 2 }
var diameter: Double { 
 // 1 line
 // 2 line
}

```

**Not Preferred:**
```swift
var diameter: Double {
  get {
    return radius * 2
  }
}
```

### Final

Marking classes or members as `final` in tutorials can distract from the main topic and is not required. Nevertheless, use of `final` can sometimes clarify your intent and is worth the cost. In the below example, `Box` has a particular purpose and customization in a derived class is not intended. Marking it `final` makes that clear.

```swift
// Turn any generic type into a reference type using this Box class.
final class Box<T> {
  let value: T
  init(_ value: T) {
    self.value = value
  }
}
```

## Function Declarations

Keep short function declarations on one line including the opening brace:

```swift
func reticulateSplines(spline: [Double]) -> Bool {
  // reticulate code goes here
}
```

For functions with long signatures, add line breaks at appropriate points and add an extra indent on subsequent lines:

```swift
func reticulateSplines(spline: [Double], adjustmentFactor: Double,
    translateConstant: Int, comment: String) -> Bool {
  // reticulate code goes here
}
```

## Closure Expressions

Use trailing closure syntax only if there's a single closure expression parameter at the end of the argument list. Give the closure parameters descriptive names.

**Preferred:**
```swift
UIView.animate(withDuration: 1.0) {
  self.myView.alpha = 0
}

UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
}, completion: { finished in
  self.myView.removeFromSuperview()
})
```

**Not Preferred:**
```swift
UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
})

UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
}) { f in
  self.myView.removeFromSuperview()
}
```

For single-expression closures where the context is clear, use implicit returns:

```swift
attendeeList.sort { a, b in
  a > b
}
```

Chained methods using trailing closures should be clear and easy to read in context. Decisions on spacing, line breaks, and when to use named versus anonymous arguments is left to the discretion of the author. Examples:

```swift
let value = numbers.map { $0 * 2 }.filter { $0 % 3 == 0 }.index(of: 90)

let value = numbers
  .map {$0 * 2}
  .filter {$0 > 50}
  .map {$0 + 10}
```

## Types

Always use Swift's native types when available. Swift offers bridging to Objective-C so you can still use the full set of methods as needed.

**Preferred:**
```swift
let width = 120.0                                    // Double
let widthString = (width as NSNumber).stringValue    // String
```

**Not Preferred:**
```swift
let width: NSNumber = 120.0                          // NSNumber
let widthString: NSString = width.stringValue        // NSString
```

In Sprite Kit code, use `CGFloat` if it makes the code more succinct by avoiding too many conversions.

### Fonts and Colors

**Tip:** A good technique is to use extension for Font, Color, Date, String and other classes.

**Preferred:**
```swift
extension UIFont {
    enum NameOfTheProject {
        enum Calendar {
            static var dayOfWeekFont = UIFont(name: "Font-Name", size: 18)
        }
        enum Navigation {
            static var button = UIFont(name: "Font-Name2", size: 18)
            static var title = UIFont(name: "Font-Name3", size: 18)
        }
    }
}

extension UIColor {
    struct CloudCard {
        struct Common {
            static let error = UIColor(red: 193.0/255.0, green: 19.0/255.0, blue: 19.0/255.0, alpha: 1.0)
            static let line = UIColor(red: 135.0/255.0, green: 135.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        }
    }
}
```

### Constants

Constants are defined using the `let` keyword, and variables with the `var` keyword. Always use `let` instead of `var` if the value of the variable will not change.

**Tip:** A good technique is to define everything using `let` and only change it to `var` if the compiler complains!

You can define constants on a type rather than on an instance of that type using type properties. To declare a type property as a constant simply use `static let`. Type properties declared in this way are generally preferred over global constants because they are easier to distinguish from instance properties. Example:

**Preferred:**
```swift
enum Constants {
 enum Math {
   static let e = 2.718281828459045235360287
   static let root2 = 1.41421356237309504880168872
 }
}
```
**Note:** The advantage of using a case-less enumeration is that it can't accidentally be instantiated and works as a pure namespace.

**Not Preferred:**
```swift
let e = 2.718281828459045235360287  // pollutes global namespace
let root2 = 1.41421356237309504880168872

let hypotenuse = side * root2 // what is root2?
```

### Static Methods and Variable Type Properties

Static methods and type properties work similarly to global functions and global variables and should be used sparingly. They are useful when functionality is scoped to a particular type or when Objective-C interoperability is required.

**Example:**
```swift
class MathHelper {
    static func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
}
```

### Optionals

Declare variables and function return types as optional with `?` where a nil value is acceptable.

Use implicitly unwrapped types declared with `!` only for instance variables that you know will be initialized later before use, such as subviews that will be set up in `viewDidLoad`.

When accessing an optional value, use optional chaining if the value is only accessed once or if there are many optionals in the chain:

```swift
self.textContainer?.textLabel?.setNeedsDisplay()
```

Use optional binding when it's more convenient to unwrap once and perform multiple operations:

```swift
if let textContainer = self.textContainer {
  // do many things with textContainer
}
```

When naming optional variables and properties, avoid naming them like `optionalString` or `maybeView` since their optional-ness is already in the type declaration.

For optional binding, shadow the original name when appropriate rather than using names like `unwrappedView` or `actualLabel`.

**Preferred:**
```swift
var subview: UIView?
var volume: Double?

// later on...
if let subview = subview, let volume = volume {
  // do something with unwrapped subview and volume
}
```

**Not Preferred:**
```swift
var optionalSubview: UIView?
var volume: Double?

if let unwrappedSubview = optionalSubview {
  if let realVolume = volume {
    // do something with unwrappedSubview and realVolume
  }
}
```

### Lazy Initialization

Consider using lazy initialization for finer grain control over object lifetime. This is especially true for `UIViewController` that loads views lazily. You can either use a closure that is immediately called `{ }()` or call a private factory method. Example:

```swift
lazy var locationManager: CLLocationManager = self.makeLocationManager()

private func makeLocationManager() -> CLLocationManager {
  let manager = CLLocationManager()
  manager.desiredAccuracy = kCLLocationAccuracyBest
  manager.delegate = self
  manager.requestAlwaysAuthorization()
  return manager
}
```

**Notes:**
  - `[unowned self]` is not required here. A retain cycle is not created.
  - Location manager has a side-effect for popping up UI to ask the user for permission so fine grain control makes sense here.


### Type Inference

Prefer compact code and let the compiler infer the type for constants or variables of single instances. Type inference is also appropriate for small (non-empty) arrays and dictionaries. When required, specify the specific type such as `CGFloat` or `Int16`.

**Preferred:**
```swift
let message = "Click the button"
let currentBounds = computeViewBounds()
var names = ["Mic", "Sam", "Christine"]
let maximumWidth: CGFloat = 106.5
```

**Not Preferred:**
```swift
let message: String = "Click the button"
let currentBounds: CGRect = computeViewBounds()
let names = [String]()
```

#### Type Annotation for Empty Arrays and Dictionaries

For empty arrays and dictionaries, use type annotation. (For an array or dictionary assigned to a large, multi-line literal, use type annotation.)

**Preferred:**
```swift
var names: [String] = []
var lookup: [String: Int] = [:]
```

**Not Preferred:**
```swift
var names = [String]()
var lookup = [String: Int]()
```

**NOTE**: Following this guideline means picking descriptive names is even more important than before.


### Syntactic Sugar

Prefer the shortcut versions of type declarations over the full generics syntax.

**Preferred:**
```swift
var deviceModels: [String]
var employees: [Int: String]
var faxNumber: Int?
```

**Not Preferred:**
```swift
var deviceModels: Array<String>
var employees: Dictionary<Int, String>
var faxNumber: Optional<Int>
```

## Functions vs Methods

Free functions, which aren't attached to a class or type, should be used sparingly. When possible, prefer to use a method instead of a free function. This aids in readability and discoverability.

Free functions are most appropriate when they aren't associated with any particular type or instance.

**Preferred**
```swift
let sorted = items.mergeSorted()  // easily discoverable
rocket.launch()  // acts on the model
```

**Not Preferred**
```swift
let sorted = mergeSort(items)  // hard to discover
launch(&rocket)
```

**Free Function Exceptions**
```swift
let tuples = zip(a, b)  // feels natural as a free function (symmetry)
let value = max(x, y, z)  // another free function that feels natural
```

## Memory Management

Code (even non-production, tutorial demo code) should not create reference cycles. Analyze your object graph and prevent strong cycles with `weak` and `unowned` references. Alternatively, use value types (`struct`, `enum`) to prevent cycles altogether.

### Extending object lifetime

Extend object lifetime using the `[weak self]` and `guard let strongSelf = self else { return }` idiom. `[weak self]` is preferred to `[unowned self]` where it is not immediately obvious that `self` outlives the closure. Explicitly extending lifetime is preferred to optional unwrapping.

**Preferred**
```swift
resource.request().onComplete { [weak self] response in
  guard let strongSelf = self else {
    return
  }
  let model = strongSelf.updateModel(response)
  strongSelf.updateUI(model)
}
```

**Not Preferred**
```swift
// might crash if self is released before response returns
resource.request().onComplete { [unowned self] response in
  let model = self.updateModel(response)
  self.updateUI(model)
}
```

**Not Preferred**
```swift
// deallocate could happen between updating the model and updating UI
resource.request().onComplete { [weak self] response in
  let model = self?.updateModel(response)
  self?.updateUI(model)
}
```

## Access Control

Full access control annotation in tutorials can distract from the main topic and is not required. Using `private` and `fileprivate` appropriately, however, adds clarity and promotes encapsulation. Prefer `private` to `fileprivate` when possible. Using extensions may require you to use `fileprivate`.

Only explicitly use `open`, `public`, and `internal` when you require a full access control specification.

Use access control as the leading property specifier. The only things that should come before access control are the `static` specifier or attributes such as `@IBAction`, `@IBOutlet` and `@discardableResult`.

**Preferred:**
```swift
private let message = "Great Scott!"

class TimeMachine {  
  fileprivate dynamic lazy var fluxCapacitor = FluxCapacitor()
}
```

**Not Preferred:**
```swift
fileprivate let message = "Great Scott!"

class TimeMachine {  
  lazy dynamic fileprivate var fluxCapacitor = FluxCapacitor()
}
```

## Control Flow

Prefer the `for-in` style of `for` loop over the `while-condition-increment` style.

**Preferred:**
```swift
for _ in 0..<3 { print("Hello three times") }

for (index, person) in attendeeList.enumerated() {
  print("\(person) is at position #\(index)")
}

attendeeList.forEach({
   print($0)
})

for index in stride(from: 0, to: items.count, by: 2) {
  print(index)
}

for index in (0...3).reversed() {
  print(index)
}
```

**Not Preferred:**
```swift
var i = 0
while i < 3 {
  print("Hello three times")
  i += 1
}

var i = 0
while i < attendeeList.count {
  let person = attendeeList[i]
  print("\(person) is at position #\(i)")
  i += 1
}
```

## Golden Path

When coding with conditionals, the left-hand margin of the code should be the "golden" or "happy" path. That is, don't nest `if` statements. Multiple return statements are OK. The `guard` statement is built for this.

**Preferred:**
```swift
func computeFFT(context: Context?, inputData: InputData?) throws -> Frequencies {
  guard let context = context else { throw FFTError.noContext }
  guard let inputData = inputData else { throw FFTError.noInputData }
  return frequencies
}
```

**Not Preferred:**
```swift
func computeFFT(context: Context?, inputData: InputData?) throws -> Frequencies {
  if let context = context {
    if let inputData = inputData {
      return frequencies
    } else {
      throw FFTError.noInputData
    }
  } else {
    throw FFTError.noContext
  }
}
```

When multiple optionals are unwrapped either with `guard` or `if let`, minimize nesting by using the compound version when possible. Example:

**Preferred:**
```swift
guard let number1 = number1,
      let number2 = number2,
      let number3 = number3 else {
  fatalError("impossible")
}
// do something with numbers
```

**Not Preferred:**
```swift
if let number1 = number1 {
  if let number2 = number2 {
    if let number3 = number3 {
      // do something with numbers
    } else {
      fatalError("impossible")
    }
  } else {
    fatalError("impossible")
  }
} else {
  fatalError("impossible")
}
```

### Failing Guards

Guard statements are required to exit in some way. Generally, this should be simple one line statement such as `return`, `throw`, `break`, `continue`, and `fatalError()`. Large code blocks should be avoided. If cleanup code is required for multiple exit points, consider using a `defer` block to avoid cleanup code duplication.

## Semicolons

Swift does not require a semicolon after each statement in your code. They are only required if you wish to combine multiple statements on a single line.

Do not write multiple statements on a single line separated with semicolons.

**Preferred:**
```swift
let swift = "not a scripting language"
```

**Not Preferred:**
```swift
let swift = "not a scripting language";
```

**NOTE**: Swift is very different from JavaScript, where omitting semicolons is [generally considered unsafe](http://stackoverflow.com/questions/444080/do-you-recommend-using-semicolons-after-every-statement-in-javascript)

## Parentheses

Parentheses around conditionals are not required and should be omitted.

**Preferred:**
```swift
if name == "Hello" { 1 line }

if name == "Hello" { 
 1 line
 2 line
 3 line
}

```

**Not Preferred:**
```swift
if (name == "Hello") {
  print("World")
}

if (name == "Hello") 
{
  print("World")
}
```

In larger expressions, optional parentheses can sometimes make code read more clearly.

**Preferred:**
```swift
let playerMark = (player == current ? "X" : "O")
```

## Multi-line String Literals

When building a long string literal, you're encouraged to use the multi-line string literal syntax. Open the literal on the same line as the assignment but do not include text on that line. Indent the text block one additional level.

**Preferred**:

```swift
let message = """
  You cannot charge the flux \
  capacitor with a 9V battery.
  You must use a super-charger \
  which costs 10 credits. You currently \
  have \(credits) credits available.
  """
```

**Not Preferred**:

```swift
let message = """You cannot charge the flux \
  capacitor with a 9V battery.
  You must use a super-charger \
  which costs 10 credits. You currently \
  have \(credits) credits available.
  """
```

**Not Preferred**:

```swift
let message = "You cannot charge the flux " +
  "capacitor with a 9V battery.\n" +
  "You must use a super-charger " +
  "which costs 10 credits. You currently " +
  "have \(credits) credits available."
```
## Concurrency

When working with concurrency in Swift, it's important to adhere to best practices for using _async/await_ and _DispatchQueue_. Ensure that you handle thread management safely to prevent data races and maintain performance. Avoid blocking the main thread to keep the UI responsive. Always use appropriate synchronization mechanisms when accessing shared resources. Additionally, be mindful of cancellation and error handling in asynchronous tasks to enhance reliability and maintainability in your code.

## No Emoji

Do not use emoji in your projects. For those readers who actually type in their code, it's an unnecessary source of friction. While it may be cute, it doesn't add to the learning and it interrupts the coding flow for these readers.

## Organization, Bundle Identifier and Folders

Where an Xcode project is involved, the organization should be set to `Weelorum` and the Bundle Identifier set to `com.weelorum.ProjectName` where `ProjectName` is the name of the project.

![Xcode Project settings](screens/project_settings.png)

**Folder structure**
All classes must reside in their respective folders. To save time, utilize ready-made templates for creating folder structures with classes and methods.

- ProjectName
  - API/
  - Application/
  - Services/
  - Extensions/
  - Helpers/
    - Constants/
    - Localization/
  - Models/
  - Views/
  - MVVM/
    - ScreenName/
      - Coordinator
      - ViewModel
      - View
  - Resources/
    - Entitlements/
    - Fonts/
    - Images/
      - Assets.xcassets
      - Images.xcassets
      - Colors.xcassets
    - LaunchScreen.storyboard
    - Plists/
      - Environments.plist
      - Info.plist
     
## Architecture Patterns: MVVM + Coordinator
MVVM (Model-View-ViewModel) is a design pattern that separates the user interface (View) from the business logic (ViewModel) and data (Model). This separation improves testability and maintainability by allowing independent development of each layer.

Coordinator pattern complements MVVM by managing navigation and flow between view controllers. Instead of having each view controller handle its own navigation, the Coordinator takes on this responsibility, resulting in a cleaner and more modular structure.

Benefits:
Enhances testability of ViewModels by isolating UI logic.
Improves code organization and reduces complexity by centralizing navigation.

**Model**
```swift
struct User {
    let name: String
}
```

**ViewModel**
```swift
class UserViewModel {
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var displayName: String {
        return "User: \(user.name)"
    }
}
```

**ViewController**
```swift
class UserViewController: UIViewController {
    var viewModel: UserViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.displayName
    }
}
```

**Coordinator**
```swift
class AppCoordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showUser(user: User) {
        let viewModel = UserViewModel(user: user)
        let userVC = UserViewController()
        userVC.viewModel = viewModel
        navigationController.pushViewController(userVC, animated: true)
    }
}
```

## Reactive Programming with RxSwift

Reactive programming is a programming paradigm focused on data streams and the propagation of change. It allows developers to build more responsive applications by managing asynchronous data flows and events efficiently.

Observables: 

Use Observable for data binding in ViewModels. This allows Views to react to changes without direct references.

```swift
let userName: BehaviorSubject<String> = BehaviorSubject(value: "Initial Name")
```

Subjects: 

Utilize PublishSubject or BehaviorSubject for events and user inputs in ViewModels.

```swift
let userAction: PublishSubject<String> = PublishSubject()
```

DisposeBag:

Always use a DisposeBag to manage memory and subscriptions.
```swift
private let disposeBag = DisposeBag()
```

## Using RxSwift in MVVM

This structure allows for clear separation of concerns, making testing and maintenance easier. In this example, `PublishSubject` allows the `UserViewModel` to react to user actions, triggering an update to the `userName`. This showcases how RxSwift can create a responsive UI while maintaining a clean separation between the `View` and `ViewModel`.

```swift
import RxSwift

class UserViewModel {
    let userName: BehaviorSubject<String> = BehaviorSubject(value: "Initial Name")
    let userAction: PublishSubject<String> = PublishSubject()
    private let disposeBag = DisposeBag()

    init() {
        userAction
            .subscribe(onNext: { [weak self] action in
                self?.updateUserName(newName: action)
            })
            .disposed(by: disposeBag)
    }

    func updateUserName(newName: String) {
        userName.onNext(newName)
    }
}

class UserViewController: UIViewController {
    var viewModel: UserViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Observe changes to userName
        viewModel.userName
            .subscribe(onNext: { name in
                print("User name updated: \(name)")
            })
            .disposed(by: disposeBag)

        // Simulate user action
        viewModel.userAction.onNext("New User Name")
    }
}
```

## Dependency Injection 
Dependency Injection is a design pattern that promotes code modularity and testability by allowing the injection of dependencies rather than hardcoding them. When injecting dependencies, prefer initializer injection for mandatory dependencies and property injection for optional ones. Use protocols to define contracts for dependencies, making it easier to swap implementations for testing. This approach facilitates the creation of mock objects in unit tests, enhancing your code's testability.

**Initializer Injection Example**:
```swift
protocol DataService {
    func fetchData() -> [String]
}

class ApiDataService: DataService {
    func fetchData() -> [String] {
        // Fetch data from API
    }
}

class ViewModel {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }
}

// Usage
let apiService = ApiDataService()
let viewModel = ViewModel(dataService: apiService)
```

**Property Injection Example**:
```swift
class ViewController: UIViewController {
    var dataService: DataService?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataService?.fetchData()
    }
}

// Usage
let viewController = ViewController()
viewController.dataService = ApiDataService()
```

## Documentation
Each project mast to have 2 files. README.md and CHANGELOG.md
 README.md contain all information about the project.
 CHANGELOG.md contain all changes to this project.

### Compile and Dependencies

We emphasize the use of [Swift Package Manager (SPM)](https://developer.apple.com/documentation/xcode/swift-packages) for managing project dependencies, as it integrates seamlessly with Xcode.

If you need to install dependencies using SPM, add the required packages in the Xcode project settings.

For [CocoaPods](https://www.cocoapods.org) users: To install CocoaPods dependencies, execute the following command in your terminal:

```
pod install
```

## Localization

We utilize R.swift for managing localization.

Ensure that you have folders for each language containing `Localizable.strings` files within the `Resources/Localization` folder, and set the encoding to UTF-16LE in the Xcode project. To update existing localizable strings, simply use the R.swift management tool.

Currently, we do not support localizing from XIBs directly, as we aim to avoid including meaningless strings in translations (like "Label," "Text," etc.) 

## About Weelorum

[<img src="https://www.weelorum.com/wp-content/uploads/2018/11/logo.png" alt="www.weelorum.com">][weelorum]

NEWPROJECT are maintained by Weelorum. We specialize in providing all-in-one solution in mobile and web development. Our team follows Lean principles and works according to agile methodologies to deliver the best results reducing the budget for development and its timeline. 

Find out more [here][weelorum] and don't hesitate to [contact us][contact]!

[weelorum]: https://www.weelorum.com
[contact]: https://www.weelorum.com

