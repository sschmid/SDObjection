Description
===========

SDObjection is modified version of [Objection] - a lightweight dependency injection framework for Objective-C for MacOS X and iOS. For those of you that have used Guice objection will feel familiar. Objection was built to stay out of your way and alleviate the need to maintain a large XML container or manually construct objects.


Features
========

* "Annotation" Based Dependency Injection
* Seamless support for integrating custom and external dependencies
  * Custom Object Providers
  * Meta Class Bindings
  * Protocol Bindings
  * Instance Bindings
* Lazily instantiates dependencies
* Eager Singletons
* Initializer Support
  * Default and custom arguments


What's new
==========
* No global context anymore
* No objection_register or objection_register_singleton
 * This is handled automatically in modules
* Injector lets you add and remove modules at any time
* Removing modules also remove their bindings


Using Objection
===============

Create an injector
```objective-c
JSObjectionInjector *injector = [JSObjection createInjector];
[JSObjection setDefaultInjector:injector];
```
Add modules
```objective-c
[injector addModule:[[SomeModule alloc] init]];
[injector addModule:[[SomeOtherModule alloc] init] withName:@"otherModule"];
```
Remove modules
```objective-c
[injector removeModuleClass:[SomeModule class]];
[injector removeModuleWithName:@"otherModule"];
[injector removeAllModules];
```
Ask
```objective-c
BOOL hasModule = [injector hasModuleClass:[SomeModule class]];
BOOL hasModuleWithName = [injector hasModuleWithName:name];
```
Configure modules
```objective-c
- (void)configure:(JSObjectionInjector *)injector {
   // I have an injector, yay!
   // Configure here
}
- (void)unload {
   // Optional unloading here. Gets called, when module gets removed.
}


// Like this
[self bindClass:[SomeObject class] toProtocol:@protocol(SomeObjectProtocol) asSingleton:YES];

// or
[self bind:[[SomeObject alloc] init] toProtocol:@protocol(SomeObjectProtocol)];

//or
[self registerSingleton:[SomeObject class]];

//or
[self registerEagerSingleton:[SomeObject class]];

//and many more
```


Use SDObjection in your project
===============================

You find the source files you need in Pods/Objection/Source

To use SDObjection with ARC, you might want to set it up with [CocoaPods] like this:

Create a Podfile and put it into your root folder of your project
Podfile
```
platform :ios, '5.0'

pod 'SDObjection'
```

Setup [CocoaPods], if not done already

```
$ sudo gem install cocoapods
$ pod setup
```

Add this remote
```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

Install SDObjection
```
$ cd path/to/project
$ pod install
```

[Objection]: https://github.com/atomicobject/objection
[CocoaPods]: http://cocoapods.org
