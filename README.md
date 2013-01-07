## Description

SDObjection is modified version of [Objection] - a lightweight dependency injection framework for Objective-C for MacOS X and iOS. For those of you that have used Guice objection will feel familiar. Objection was built to stay out of your way and alleviate the need to maintain a large XML container or manually construct objects.

## Features

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


## What's different from [Objection]

* No global context
* No objection_register or objection_register_singleton
 * This is handled automatically in modules
* Injector lets you add and remove modules at any time
* Removing modules also remove their bindings
* Injector lets you inject into existing objects

## Using SDObjection

#### Create an injector

```objective-c
JSObjectionInjector *injector = [JSObjection createInjector];
[JSObjection setDefaultInjector:injector];
```

#### Add modules

```objective-c
[injector addModule:[[SomeModule alloc] init]];
[injector addModule:[[SomeOtherModule alloc] init] withName:@"otherModule"];
```

#### Remove modules

```objective-c
[injector removeModuleInstance:someModule];
[injector removeModuleClass:[SomeModule class]];
[injector removeModuleWithName:@"otherModule"];
[injector removeAllModules];
```

#### Ask

```objective-c
BOOL hasModule = [injector hasModuleClass:[SomeModule class]];
BOOL hasModuleWithName = [injector hasModuleWithName:name];
```

#### Configure modules

```objective-c
- (void)configure {
    [super configure];

   // Configure here

   [self bindClass:[Foo class] toProtocol:@protocol(FooProtocol) asSingleton:YES];
   [self bind:[[Bar alloc] init] toProtocol:@protocol(BarProtocol)];
   [self registerSingleton:[SingleFoo class]];
   [self registerEagerSingleton:[EagerBar class]];
   
   // there are many more binding options...
}

- (void)start {
    [super start];

    // All configured bindings are ready to use
    [[self.injector getObject:@protocol(BarProtocol)] bar];
    [[self.injector getObject:[SingleFoo class]] foo];
}

- (void)unload {
   
   // Optional unloading here. Gets called, when modules get removed.
   // All configured bindings will get removed automatically.
 
   [super unload];
}
```

## Use SDObjection in your project

You find the source files you need in Pods/Objection/Source

To use SDObjection with ARC, you might want to set it up with [CocoaPods] like this:

Create a Podfile and put it into your root folder of your project

#### Edit your Podfile
```
platform :ios, '5.0'

pod 'SDObjection'
```

#### Setup [CocoaPods], if not done already

```
$ sudo gem install cocoapods
$ pod setup
```

#### Add this remote
```
$ pod repo add sschmid-cocoapods-specs https://github.com/sschmid/cocoapods-specs
```

#### Install SDObjection
```
$ cd path/to/project
$ pod install
```

## Other projects using SDObjection
If you enjoy using SDObjection in your projects let me know, and I'll mention your projects here.

[Objection]: https://github.com/atomicobject/objection
[CocoaPods]: http://cocoapods.org
