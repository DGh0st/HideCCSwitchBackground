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