@interface CCUIControlCenterButton : UIButton
@end

@interface CCUIControlCenterPushButton : CCUIControlCenterButton
@end

@interface _FSSwitchButton : UIButton
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
%end

%group polus
@interface NCMaterialView : UIView
@end

@interface PLQuickLaunchButton : CCUIControlCenterPushButton
-(NCMaterialView *)maskingMaterialView;
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

%ctor {
	%init(all);

	dlopen("/Library/MobileSubstrate/DynamicLibraries/Polus.dylib", RTLD_LAZY);
	if (%c(PLQuickLaunchButton))
		%init(polus);
}