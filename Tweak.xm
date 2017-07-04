@interface CCUIControlCenterButton : UIButton
@end

@interface CCUIControlCenterPushButton : CCUIControlCenterButton
@end

%group all
%hook _FSSwitchButton
-(void)layoutSubviews {
	%orig();

	UIImageView *backgroundView = MSHookIvar<UIImageView *>(self, "backgroundView");
	if (backgroundView != nil)
		[backgroundView setHidden:YES];
}
%end

%hook CCUIControlCenterPushButton
-(void)layoutSubviews {
	%orig();
	
	UIView *_backgroundFlatColorView = MSHookIvar<UIView *>(self, "_backgroundFlatColorView");
	if (_backgroundFlatColorView != nil)
		[_backgroundFlatColorView setHidden:YES];
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
%end
%end

%ctor {
	%init(all);

	dlopen("/Library/MobileSubstrate/DynamicLibraries/Polus.dylib", RTLD_LAZY);
	if (%c(PLQuickLaunchButton))
		%init(polus);
}