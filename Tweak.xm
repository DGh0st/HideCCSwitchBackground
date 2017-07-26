@interface CCUIControlCenterButton : UIButton
-(NSInteger)_currentState; // 0 = off, 1 = on
-(void)_updateGlyphAndTextForStateChange;
@end

@interface CCUIControlCenterPushButton : CCUIControlCenterButton
@end

@interface _FSSwitchButton : UIButton
@end

@interface FSSwitchPanel : NSObject
+(id)sharedPanel;
-(NSInteger)stateForSwitchIdentifier:(NSString *)arg1;
@end

typedef enum {
	FSSwitchStateOff = 0,
	FSSwitchStateOn = 1,
	FSSwitchStateIndeterminate = -1
} FSSwitchState;

@interface CALayer (HideCCSwitchBackground)
@property (assign) CGColorRef contentsMultiplyColor;
@end

%group all
%hook _FSSwitchButton
-(void)layoutSubviews {
	%orig();

	UIImageView *backgroundView = MSHookIvar<UIImageView *>(self, "backgroundView");
	if (backgroundView != nil)
		[backgroundView setHidden:YES];
}

-(void)_setBackgroundColor:(id)arg1 {
	%orig(nil);
}

-(id)_backgroundColor {
	return nil;
}
%end

%hook CCUIControlCenterButton
-(void)layoutSubviews {
	%orig();
	
	UIView *_backgroundFlatColorView = MSHookIvar<UIView *>(self, "_backgroundFlatColorView");
	if (_backgroundFlatColorView != nil)
		[_backgroundFlatColorView setHidden:YES];
}

-(void)_setBackgroundColor:(id)arg1 {
	%orig(nil);
}

-(id)_backgroundColor {
	return nil;
}
%end

%hook MPUEmptyNowPlayingView
-(void)setBackgroundColor:(id)arg1 {
	%orig(nil);
}

-(id)backgroundColor {
	return nil;
}
%end
%end

%group polus
@interface NCMaterialView : UIView
@end

@interface PLQuickLaunchButton : CCUIControlCenterPushButton
-(NCMaterialView *)maskingMaterialView;
-(void)updateImages;
@end

%hook PLQuickLaunchButton
-(void)layoutSubviews {
	%orig();

	[[self maskingMaterialView] setHidden:YES];
}

-(void)_setBackgroundColor:(id)arg1 {
	%orig(nil);
}

-(id)_backgroundColor {
	return nil;
}
%end
%end

%group noctis
%hook UIImageView
-(void)setTintColor:(UIColor *)arg1 {
	if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)) {
		if ([[[self superview] class] isEqual:%c(_FSSwitchButton)] && [[%c(FSSwitchPanel) sharedPanel] stateForSwitchIdentifier:MSHookIvar<NSString *>([self superview], "switchIdentifier")] != FSSwitchStateOn) {
			arg1 = [arg1 colorWithAlphaComponent:0.5];
		} else if ([[[self superview] class] isEqual:%c(CCUIControlCenterButton)] || [[[self superview] class] isEqual:%c(CCUIControlCenterPushButton)]) {
			if ([(CCUIControlCenterButton *)[self superview] _currentState] != 1 && [self isEqual:MSHookIvar<UIImageView *>([self superview], "_glyphImageView")])
				arg1 = [arg1 colorWithAlphaComponent:0.5];
		} else if ([[[self superview] class] isEqual:%c(PLFlipswitchButton)] || [[[self superview] class] isEqual:%c(PLQuickLaunchButton)]) {
			if ([(CCUIControlCenterButton *)[self superview] _currentState] != 1 && [self isEqual:MSHookIvar<UIImageView *>([self superview], "_glyphImageView")])
				arg1 = [arg1 colorWithAlphaComponent:0.5];
		}
	}

	%orig(arg1);
}

-(UIColor *)tintColor {
	UIColor *result = %orig();
	if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL)) {
		if ([[[self superview] class] isEqual:%c(_FSSwitchButton)] && [[%c(FSSwitchPanel) sharedPanel] stateForSwitchIdentifier:MSHookIvar<NSString *>([self superview], "switchIdentifier")] != FSSwitchStateOn) {
			result = [result colorWithAlphaComponent:0.5];
		} else if (([[[self superview] class] isEqual:%c(CCUIControlCenterButton)] || [[[self superview] class] isEqual:%c(CCUIControlCenterPushButton)])) {
			if ([(CCUIControlCenterButton *)[self superview] _currentState] != 1 && [self isEqual:MSHookIvar<UIImageView *>([self superview], "_glyphImageView")])
				result = [result colorWithAlphaComponent:0.5];
		} else if ([[[self superview] class] isEqual:%c(PLFlipswitchButton)] || [[[self superview] class] isEqual:%c(PLQuickLaunchButton)]) {
			if ([(CCUIControlCenterButton *)[self superview] _currentState] != 1 && [self isEqual:MSHookIvar<UIImageView *>([self superview], "_glyphImageView")])
				result = [result colorWithAlphaComponent:0.5];
		}
	}
	return result;
}
%end

%hook CALayer
-(void)setContentsMultiplyColor:(CGColorRef)arg1 {
	if (self.delegate != nil && [[self.delegate class] isEqual:[UIImageView class]]) {
		if (([[[self.delegate superview] class] isEqual:%c(CCUIControlCenterButton)] || [[[self.delegate superview] class] isEqual:%c(CCUIControlCenterPushButton)]) && [self.delegate isEqual:MSHookIvar<UIImageView *>([self.delegate superview], "_glyphImageView")]) {
			if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL))
				arg1 = ((UIImageView *)(self.delegate)).tintColor.CGColor;
			else
				arg1 = [UIColor blackColor].CGColor;
		} else if (([[[self.delegate superview] class] isEqual:%c(PLFlipswitchButton)] || [[[self.delegate superview] class] isEqual:%c(PLQuickLaunchButton)]) && [self.delegate isEqual:MSHookIvar<UIImageView *>([self.delegate superview], "_glyphImageView")]) {
			if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL))
				arg1 = ((UIImageView *)(self.delegate)).tintColor.CGColor;
			else
				arg1 = [UIColor blackColor].CGColor;
		}
	}

	%orig(arg1);
}

-(CGColorRef)contentsMultiplyColor {
	CGColorRef result = %orig();
	if (self.delegate != nil && [[self.delegate class] isEqual:[UIImageView class]]) {
		if (([[[self.delegate superview] class] isEqual:%c(CCUIControlCenterButton)] || [[[self.delegate superview] class] isEqual:%c(CCUIControlCenterPushButton)]) && [self.delegate isEqual:MSHookIvar<UIImageView *>([self.delegate superview], "_glyphImageView")]) {
			if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL))
				result = ((UIImageView *)(self.delegate)).tintColor.CGColor;
			//else
			//	result = [UIColor blackColor].CGColor;
		} else if (([[[self.delegate superview] class] isEqual:%c(PLFlipswitchButton)] || [[[self.delegate superview] class] isEqual:%c(PLQuickLaunchButton)]) && [self.delegate isEqual:MSHookIvar<UIImageView *>([self.delegate superview], "_glyphImageView")]) {
			if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL))
				result = ((UIImageView *)(self.delegate)).tintColor.CGColor;
			//else
			//	result = [UIColor blackColor].CGColor;
		}
	}
	return result;
}

-(CGColorRef)backgroundColor {
	CGColorRef result = %orig();
	if (self.delegate != nil && [[self.delegate class] isEqual:%c(MPUEmptyNowPlayingView)])
		if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL))
			result = [UIColor clearColor].CGColor;
	return result;
}

-(void)setBackgroundColor:(CGColorRef)arg1 {
	if (self.delegate != nil && [[self.delegate class] isEqual:%c(MPUEmptyNowPlayingView)])
		if (CFPreferencesGetAppBooleanValue((CFStringRef)@"LQDDarkModeEnabled", CFSTR("com.laughingquoll.noctis"), NULL))
			arg1 = [UIColor clearColor].CGColor;
	%orig(arg1);
}
%end
%end

%ctor {
	%init(all);

	dlopen("/Library/MobileSubstrate/DynamicLibraries/Polus.dylib", RTLD_LAZY);
	if (%c(PLQuickLaunchButton))
		%init(polus);

	dlopen("/Library/MobileSubstrate/DynamicLibraries/Noctis.dylib", RTLD_LAZY);
	if (%c(LQDNightSectionController))
		%init(noctis);
}
